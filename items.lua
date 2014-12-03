minetest.register_craftitem("mteconomy:coin", {
	inventory_image = "coin.png",
	description = "A gold coin.",
	stack_max = 5000,
})

minetest.register_craft({
        type = "cooking",
		recipe = "default:gold_ingot",
		output = "mteconomy:coin 100",
})
