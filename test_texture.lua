require('room_texture')


world = gr.texture("earth.png")
--box = gr.texture("crate01.png")
--wall = gr.texture("1.png")
scene = gr.node('root')
scene:add_child(room)

s1 = gr.nh_sphere('s1', {0, 1, -10}, 2)
s1:set_material(world)
scene:add_child(s1)



l1 = gr.light({0, 3, 10}, {0.5, 0.5, 0.5}, {1, 0, 0})
l2 = gr.light({0, 3, -20}, {0.5, 0.5, 0.5}, {1, 0, 0})

gr.render(scene, 'test_texture.png', 512, 512,
	  {0, 0, 0}, {0, 0, -1}, {0, 1, 0}, 50,
	  {0.3, 0.3, 0.3}, {l1, l2})
