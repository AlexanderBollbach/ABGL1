//
//  ViewController.m
//  GLTest1
//
//  Created by alexanderbollbach on 7/29/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ViewController.h"






typedef struct {
   GLKVector3  position;
   GLKVector3  normal;
}
SceneVertex;

typedef struct {
   SceneVertex vertices[3];
}
SceneTriangle;


static const SceneVertex vertexA = {{-0.5,  0.5, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexB = {{-0.5,  0.0, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexC = {{-0.5, -0.5, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexD = {{ 0.0,  0.5, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexE = {{ 0.0,  0.0, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexF = {{ 0.0, -0.5, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexG = {{ 0.5,  0.5, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexH = {{ 0.5,  0.0, -0.5}, {0.0, 0.0, 1.0}};
static const SceneVertex vertexI = {{ 0.5, -0.5, -0.5}, {0.0, 0.0, 1.0}};


static SceneTriangle SceneTriangleMake(const SceneVertex vertexA,
                                       const SceneVertex vertexB,
                                       const SceneVertex vertexC) {
   SceneTriangle   result;
   
   result.vertices[0] = vertexA;
   result.vertices[1] = vertexB;
   result.vertices[2] = vertexC;
   
   return result;
}







@interface ViewController () {
   
   
   SceneTriangle triangles[8];
   GLuint pos;
}

@end

@implementation ViewController





GLKVector3 SceneVector3UnitNormal(const GLKVector3 vectorA, const GLKVector3 vectorB) {
   
   // Returns a unit vector in the same direction as the cross product of vectorA and VectorB
   return GLKVector3Normalize(GLKVector3CrossProduct(vectorA, vectorB));
}


static GLKVector3 SceneTriangleFaceNormal(const SceneTriangle triangle) {
   
   // This function returns the face normal vector for triangle.
   GLKVector3 vectorA = GLKVector3Subtract(triangle.vertices[1].position,
                                           triangle.vertices[0].position);
   GLKVector3 vectorB = GLKVector3Subtract(triangle.vertices[2].position,
                                           triangle.vertices[0].position);
   
   return SceneVector3UnitNormal(vectorA,vectorB);
}



- (IBAction)pyramidslider:(UISlider *)sender {
   
   SceneVertex newVertexE = vertexE;
   newVertexE.position.z = sender.value;
   
   triangles[2] = SceneTriangleMake(vertexD, vertexB, newVertexE);
   triangles[3] = SceneTriangleMake(newVertexE, vertexB, vertexF);
   triangles[4] = SceneTriangleMake(vertexD, newVertexE, vertexH);
   triangles[5] = SceneTriangleMake(newVertexE, vertexF, vertexH);
   
   
   for (int i=0; i<8; i++)
   {
      GLKVector3 faceNormal = SceneTriangleFaceNormal(triangles[i]);
      triangles[i].vertices[0].normal = faceNormal;
      triangles[i].vertices[1].normal = faceNormal;
      triangles[i].vertices[2].normal = faceNormal;
   }
   
   glBindBuffer(GL_ARRAY_BUFFER, pos);
   
   glBufferData(GL_ARRAY_BUFFER,
                sizeof(SceneVertex) * (sizeof(triangles) / sizeof(SceneVertex)),
                triangles,
                GL_DYNAMIC_DRAW);
   
   
}

- (IBAction)slider2:(UISlider *)sender {
   
   self.baseEffect.light0.position = GLKVector4Make(0.5,
                                                    sender.value,
                                                    1.0,
                                                    0.0);
}


- (IBAction)transformSlider:(UISlider *)sender {
   
   float slideValue = (sender.value * 180);
   
   GLKMatrix4 m = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(slideValue), 0, 1, 0);
   
   self.baseEffect.transform.modelviewMatrix = m;
}



- (void)viewDidLoad {
   [super viewDidLoad];
   
   
   
   
   GLKView *view = (GLKView *)self.view;
   NSAssert([view isKindOfClass:[GLKView class]],@"View controller's view is not a GLKView");
   
   view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
   
   [EAGLContext setCurrentContext:view.context];
   
   self.baseEffect = [[GLKBaseEffect alloc] init];
   
   
   
   self.baseEffect.light0.enabled = GL_TRUE;
   self.baseEffect.light0.diffuseColor = GLKVector4Make(1,
                                                        1,
                                                        1,
                                                        1.0f);
   self.baseEffect.light0.position = GLKVector4Make(0.5f,
                                                    0.5f,
                                                    0.5f,
                                                    0);
   
   
   {  // Comment out this block to render the scene top down
      
      
      //            GLKMatrix4 modelViewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-60.0f), 1.0f, 0.0f, 0.0f);
      //            modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(-30.0f), 0.0f, 0.0f, 1.0f);
      //            modelViewMatrix = GLKMatrix4Translate(modelViewMatrix,0.0f, 0.0f, 0.25f);
      //
      //            self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
   }
   
   glClearColor(0,0,0,1);
   
   SceneTriangle tri0 = SceneTriangleMake(vertexA, vertexB, vertexD);
   SceneTriangle tri1 = SceneTriangleMake(vertexB, vertexC, vertexF);
   SceneTriangle tri2 = SceneTriangleMake(vertexD, vertexB, vertexE);
   SceneTriangle tri3 = SceneTriangleMake(vertexE, vertexB, vertexF);
   SceneTriangle tri4 = SceneTriangleMake(vertexD, vertexE, vertexH);
   SceneTriangle tri5 = SceneTriangleMake(vertexE, vertexF, vertexH);
   SceneTriangle tri6 = SceneTriangleMake(vertexG, vertexD, vertexH);
   SceneTriangle tri7 = SceneTriangleMake(vertexH, vertexF, vertexI);
   
   
   triangles[0] = tri0;
   triangles[1] = tri1;
   triangles[2] = tri4;
   triangles[3] = tri5;
   triangles[4] = tri2;
   triangles[5] = tri3;
   triangles[6] = tri6;
   triangles[7] = tri7;
   
   
   glGenBuffers(1, &pos);
   
   
   
   glBindBuffer(GL_ARRAY_BUFFER,
                pos);
   
   
   glBufferData(GL_ARRAY_BUFFER,  // Initialize buffer contents
                sizeof(SceneVertex) * (sizeof(triangles) / sizeof(SceneVertex)),
                triangles,          // Address of bytes to copy
                GL_DYNAMIC_DRAW);           // Hint: cache in GPU memory
   
   
   
}



- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
   
   
   
   
   
   [self.baseEffect prepareToDraw];
   
   glClear(GL_COLOR_BUFFER_BIT);
   
   glBindBuffer(GL_ARRAY_BUFFER,pos);
   
   glEnableVertexAttribArray(GLKVertexAttribPosition);
   
   const GLvoid * off1 = NULL + offsetof(SceneVertex, position) ;
   
   glVertexAttribPointer(GLKVertexAttribPosition,               // Identifies the attribute to use
                         3,               // number of coordinates for attribute
                         GL_FLOAT,            // data is floating point
                         GL_FALSE,            // no fixed point scaling
                         sizeof(SceneVertex),         // total num bytes stored per vertex
                         off1);
   
   
   
   
   
   
   glEnableVertexAttribArray(GLKVertexAttribNormal);
   
   
   const GLvoid * off2 = NULL + offsetof(SceneVertex, normal) ;
   
   glVertexAttribPointer(GLKVertexAttribNormal,               // Identifies the attribute to use
                         3,               // number of coordinates for attribute
                         GL_FLOAT,            // data is floating point
                         GL_FALSE,            // no fixed point scaling
                         sizeof(SceneVertex),         // total num bytes stored per vertex
                         off2);
   
   
   GLenum error = glGetError();
   if(GL_NO_ERROR != error)
   {
      NSLog(@"GL Error: 0x%x", error);
   }
   
   
   int sizeOfTries = sizeof(triangles);
   int sizeOfSceneVertex = sizeof(SceneVertex);
   
   int numArraysToDraw = sizeOfTries / sizeOfSceneVertex;
   
   glDrawArrays(GL_TRIANGLES, 0, numArraysToDraw);
   
}












@end
