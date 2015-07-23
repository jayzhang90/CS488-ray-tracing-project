#include "a4.hpp"
#include "image.hpp"

bool antiAliasing =false;
int num_dof_rays=2;

Matrix4x4 pixel_from_vcs_to_wcs(int width, int height, double fov, double d, Point3D eye, Vector3D view, Vector3D up){
   Matrix4x4 step1_translate = Matrix4x4(
    Vector4D(1.0, 0.0, 0.0, -width/2),
    Vector4D(0.0, 1.0, 0.0, -height/2),
    Vector4D(0.0, 0.0, 1.0, d),
    Vector4D(0.0, 0.0, 0.0, 1.0));

 double h= 2.0 * d* tan(fov*M_PI / 360.0f);
// Matrix4x4 step2_scale = Matrix4x4().scale(-h / height, -h / height, 1.0);
  Matrix4x4 step2_scale = Matrix4x4(
    Vector4D(-h/width, 0.0, 0.0, 0.0),
    Vector4D(0.0, -h/height, 0.0, 0.0),
    Vector4D(0.0, 0.0, 1.0, 0.0),
    Vector4D(0.0, 0.0, 0.0, 1.0));
view.normalize();
 up.normalize();
Vector3D u = up.cross(view);
  u.normalize();
  Vector3D v = view.cross(u);


  v.normalize();
 
 // Matrix4x4 step3_rotate=Matrix4x4(Vector4D(u, 0.0), Vector4D(v, 0.0), Vector4D(view, 0.0), Vector4D(0.0, 0.0, 0.0, 1.0)).transpose();
Matrix4x4 step3_rotate=Matrix4x4(Vector4D(u[0], v[0], view[0], 0.0),Vector4D(u[1], v[1], view[1], 0.0),Vector4D(u[2], v[2], view[2], 0.0),Vector4D(0.0, 0.0, 0.0, 1.0));
 // Matrix4x4 step4_translate=Matrix4x4().translate(eye[0],eye[1],eye[2]);
 Matrix4x4 step4_translate= Matrix4x4(
    Vector4D(1.0, 0.0, 0.0, eye[0]),
  Vector4D(0.0, 1.0, 0.0, eye[1]),
    Vector4D(0.0, 0.0, 1.0, eye[2]),
    Vector4D(0.0, 0.0, 0.0, 1.0));

  return step4_translate* step3_rotate *step2_scale* step1_translate;
} 

void a4_render(// What to render
               SceneNode* root,
               // Where to output the image
               const std::string& filename,
               // Image size
               int width, int height,
               // Viewing parameters
               const Point3D& eye, const Vector3D& view,
               const Vector3D& up, double fov,
               // Lighting parameters
               const Colour& ambient,
               const std::list<Light*>& lights,
                double focal_length,
         double aperture
        
               )
{
  // Fill in raytracing code here.

  std::cerr << "Stub: a4_render(" << root << ",\n     "
            << filename << ", " << width << ", " << height << ",\n     "
            << eye << ", " << view << ", " << up << ", " << fov << ",\n     "
            << ambient << ",\n     {";

  for (std::list<Light*>::const_iterator I = lights.begin(); I != lights.end(); ++I) {
    if (I != lights.begin()) std::cerr << ", ";
    std::cerr << **I;
  }
  std::cerr << "});" << std::endl;
  

//for(int i=0;i<80;i=i+1){
// focal_length=focal_length-0.10;

 Vector3D w = view;
  w.normalize();
  Vector3D u = up.cross(w);
  u.normalize();
  Vector3D v = w.cross(u);
Matrix4x4 change_Coordinate =pixel_from_vcs_to_wcs(width, height, fov, focal_length, eye, view, up);
  Image img(width, height, 3);
int one_percent = width*height*0.01;
  int count = 0, percentage = 0;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {

      Colour bg(0.0, 0.0, 0);
      Colour pixel_colour(0.0, 0.0, 0.0);
      Point3D pixel(x,y,0.0);
      Point3D pixel_world = change_Coordinate * pixel;
       Vector3D ray = pixel_world-eye;

      if(antiAliasing){
        //std::cout<<"antiAliasing\n";
        for ( int i = 0; i < 4; i++) {
      for( int j = 0; j < 4; j++) {
      double subpix_side = 1.0 / 4;
      double r1 = (double) (rand() % 100) / 100.0;
      double r2 = (double) (rand() % 100) / 100.0;
      Point3D subpix = Point3D((double) x + subpix_side * (i + r1), 
                   (double) y + subpix_side* (j + r2), 0.0);
      Point3D subpix_world = change_Coordinate * subpix;
      Vector3D ray = subpix_world- eye;
        Colour c = root->get_colour(eye, ray, ambient, bg, lights);
        pixel_colour = pixel_colour + c;
      }
    }


    pixel_colour = (1.0 / 16) * pixel_colour;

  }

      else{
    
      
      ///////////////////////////Depth of field
      if(aperture > 0)
      {// std::cout<<"dof\n";
        ray.normalize();
        Point3D focalPoint = eye + focal_length * ray;
        Colour dc(0.0, 0.0, 0.0);
        for ( int k = 0; k < num_dof_rays; k++) {
        double dx = ((double)(rand() % 100) / 100.0) * aperture; 
        double dy = ((double)(rand() % 100) / 100.0) * aperture; 
        Point3D n_eye = eye + dx * u + dy * v;
        Vector3D fray = focalPoint - n_eye;
        Colour c = root->get_colour(n_eye, fray, ambient, bg, lights);
        dc = dc + c;
        }
        dc = (1.0 / num_dof_rays) * dc;
        pixel_colour = pixel_colour + dc;
      }
      else{
        Colour c = root->get_colour(eye, ray, ambient, bg, lights); //////0 need to remove
        pixel_colour = pixel_colour + c;
      }

      
  }
   img(x, y, 0) = pixel_colour.R();
    img(x, y, 1) = pixel_colour.G();
    img(x, y, 2) = pixel_colour.B();


    if(++count >= one_percent)
      {
        count = 0;
        std::cout << "progress: " << ++percentage << "% \r" << std::flush;
      }
  }
}
//std::string c= std::to_string(focal_length); 

  //img.savePng(c+filename);
  //std::cout<<i<<std::endl;

//}
  img.savePng(filename);
}
