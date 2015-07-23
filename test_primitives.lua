require('room')

gold = gr.material({0.9, 0.8, 0.4}, {0.8, 0.8, 0.4}, 25)
grass = gr.material({0.1, 0.7, 0.1}, {0.0, 0.0, 0.0}, 0)
blue = gr.material({0.7, 0.6, 1}, {0.5, 0.4, 0.8}, 25)
black =gr.material({0, 0, 0}, {0, 0, 0}, 0)
silver = gr.material({0.8,0.8,0.8},{0.8,0.8,0.8},25)
world = gr.texture("earth.png")

scene = gr.node('root')
scene:add_child(room)


b1 = gr.cylinder('b1')
b1:translate(-1, -1, -10)
b1:scale(1, 1.5, 1)
b1:rotate('x', 10)

b1:set_material(blue)
scene:add_child(b1)

b2 = gr.cone('b2')
b2:translate(2, -1, -10)
b2:scale(1, 1.5, 1)
b2:rotate('x', 10)

b2:set_material(blue)
scene:add_child(b2)

l1 = gr.light({0, 3, 10}, {0.5, 0.5, 0.5}, {1, 0, 0})
l2 = gr.light({0, 3, -20}, {0.5, 0.5, 0.5}, {1, 0, 0})

gr.render(scene, 'test_primitive.png', 512, 512,
	  {0, 0, 0}, {0, 0, -1}, {0, 1, 0}, 50,
	  {0.3, 0.3, 0.3}, {l1, l2})
