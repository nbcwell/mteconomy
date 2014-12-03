minetest.register_craftitem("mteconomy:coin", {
	inventory_image = "coin.png",
	description = "A gold coin.",
	stackmax = 500,
})

minetest.register_craft({
        type = "cooking",
		recipe = "default:gold_ingot",
		output = "mteconomy:coin",
})
