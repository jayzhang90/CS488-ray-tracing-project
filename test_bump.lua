require('room_texture')


stone = gr.material({0.8, 0.7, 0.7}, {0.0, 0.0, 0.0}, 0)
stone:set_normal_map("normal_map.png")
red = gr.material({1.0, 0.0, 0.0}, {0.3, 0.3, 0.3}, 20)
red:set_bump_map("normal_map.png")

scene = gr.node('root')
scene:add_child(room)

b1 = gr.sphere('b1')
b1:translate(-1, 0, -10)
b1:scale(3, 3, 3)
b1:rotate('z', 30)
b1:rotate('y', 45)
b1:rotate('x', 45)
b1:set_material(stone)


scene:add_child(b1)


l1 = gr.light({0, 0, 0}, {0.8, 0.8, 0.8}, {1, 0, 0})
l3 = gr.light({0, 50, 0}, {0.7, 0.7, 0.7}, {1, 0, 0})

gr.render(scene, 'test_bump.png', 512, 512,
	  {0, 0, 0}, {0, 0, -1}, {0, 1, 0}, 50,
	  {0.3, 0.3, 0.3}, {l1, l3})

