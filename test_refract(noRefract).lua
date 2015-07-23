stone = gr.material({0.8, 0.7, 0.7}, {0.0, 0.0, 0.0}, 0)
--stone:set_normal_map("earth.png")
mat3 = gr.material({1.0, 0.6, 0.1}, {0.5, 0.7, 0.5}, 25)
hide = gr.material({0.84, 0.6, 0.53}, {0.3, 0.3, 0.3}, 20)
red = gr.material({1.0, 0.0, 0.0}, {0.3, 0.3, 0.3}, 20)
blue = gr.material({1.0, 1.0, 0.0}, {0.3, 0.3, 0.3}, 20,0.8,1.5)
mat1 = gr.material({0.7, 1.0, 0.7}, {0.5, 0.7, 0.5}, 25)
mat2 = gr.material({0.5, 0.5, 0.5}, {0.5, 0.7, 0.5}, 25)
scene = gr.node('root')



s2 = gr.nh_sphere('s2', {2, 0, -15}, 2)
scene:add_child(s2)
s2:set_material(mat3)

s3 = gr.nh_sphere('s3', {0, 2, -15}, 2)
scene:add_child(s3)
s3:set_material(red)

s4 = gr.nh_sphere('s4', {2, 2, -15}, 2)
scene:add_child(s4)
s4:set_material(mat1)

s5 = gr.nh_sphere('s5', {0, 0, -15}, 2)
scene:add_child(s5)
s5:set_material(mat2)

b1 = gr.nh_box('b1', {0, 0, -55}, 32)
scene:add_child(b1)
b1:set_material(stone)

l1 = gr.light({0, 0, 10}, {0.3, 0.3, 0.3}, {1, 0, 0})
l2 = gr.light({0, 5, -20}, {1.0, 1.0, 1.0}, {1, 0, 0})

gr.render(scene, 'test_refract-compare.png', 512, 512,
	  {0, 0, 0}, {0, 0, -1}, {0, 1, 0}, 50,
	  {0.3, 0.3, 0.3}, {l1, l2})
