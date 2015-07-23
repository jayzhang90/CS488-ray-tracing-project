require('room')
-- materials
require('materials')

-- need this to read obj files
require('readobj')


-- Scene root
scene = gr.node('scene')
scene:add_child(room)

radius = 0.58
length = 10
blue = gr.material({0.4, 0.6, 1}, {0.0, 0.0, 0.0}, 25, 0.96, 1.6666)

white = gr.material({1.0, 1.0, 1.0}, {0, 0, 0}, 5)

teapot = gr.mesh('teapot', readobj('teapot_n.obj'))
scene:add_child(teapot)
teapot:set_material(white)
teapot:translate(-0.05, 0, -3.1)
teapot:scale(radius, radius, radius)

b1 = gr.nh_box('b1', {0, 0, -55}, 32)
scene:add_child(b1)
b1:set_material(blue)

-- lights
light_color = {0.780131, 0.780409, 0.775833}
light_color_2 = {0.780131/2, 0.780409/2, 0.775833/2}
light_color_3 = {1.0, 1.0, 1.0}

-- on ceiling
light1 = gr.light({5, 10, -10}, light_color, {1, 0, 0}, {0, -1, 0})
--light2 = gr.disc_light({0, 0, -4}, light_color_2, {1, 0, 0}, {0, 0, 1}, 2)

gr.render(scene,
	  'mesh.png', 128, 128,
	  {0, 1, -4.5}, {0, -2.871199, 4.612095}, {0, 1, 0}, 50,
	  {0.1,0.1,0.1}, {light1})

