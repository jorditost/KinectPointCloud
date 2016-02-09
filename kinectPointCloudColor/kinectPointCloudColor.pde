import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

// variable to hold our current rotation
// represented in degrees
float rotation = 0;

void setup() {
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  // access the color camera
  kinect.enableRGB();
  
  // tell OpenNI to line-up the color pixels
  // with the depth data
  kinect.alternativeViewPointDepthToImage();
}

void draw() {
  background(0);
  kinect.update();
  
  // load the color image from the Kinect
  PImage rgbImage = kinect.rgbImage();

  // prepare to draw centered in x-y
  // pull it 1000 pixels closer on z
  translate(width/2, height/2, 0);
  //translate(width/2, height/2, -1000);
  
  // flip the point cloud vertically:
  rotateX(radians(180));

  // move the center of rotation
  // to inside the point cloud
  translate(0, 0, 1000);

  // rotate about the y-axis
  // and bump the rotation
  rotateY(radians(rotation));
  //rotation++;

  PVector[] depthPoints = kinect.depthMapRealWorld();

  // don't skip any depth points
  for (int i = 0; i < depthPoints.length; i+=2) {
    PVector currentPoint = depthPoints[i];
    // set the stroke color based on the color pixel
    stroke(rgbImage.pixels[i]);
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
}

void keyPressed() {
  if (keyCode == LEFT) {
    rotation--;
  } else if (keyCode == RIGHT) {
    rotation++;
  }
}
