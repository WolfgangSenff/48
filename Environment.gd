extends TileMap

onready var astar_map = AStar2D.new()
var cell_id_map = { }

const Grass = 7
const Dirt = 9
const Brick = 10


const WalkableTiles = [Grass, Dirt, Brick]
const Neighbors = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]

func _ready() -> void:
    var used_cells = get_used_cells()
    
    for cell in used_cells:
        var next_id = astar_map.get_available_point_id()
        var cell_id = get_cellv(cell)
        if cell_id in WalkableTiles:
            astar_map.add_point(next_id, cell, 1)
            cell_id_map[cell] = next_id
    
    for cell in cell_id_map.keys():
        var cell_id = cell_id_map[cell]
        for neighbor in Neighbors:
            var neighbor_cell = cell + neighbor
            if cell_id_map.has(neighbor_cell):
                var neighbor_id = cell_id_map[neighbor_cell]
                astar_map.connect_points(cell_id, neighbor_id, false)


func get_astar_path(begin_position : Vector2, end_position : Vector2) -> Array:
    var begin_cell = world_to_map(begin_position)
    var end_cell = world_to_map(end_position)
    var new_path = []
    
    if cell_id_map.has(begin_cell) and cell_id_map.has(end_cell):
        var begin_id = cell_id_map[begin_cell]
        var end_id = cell_id_map[end_cell]
        var path = astar_map.get_point_path(begin_id, end_id)
        for point in path:
            var new_point = map_to_world(point) + (cell_size / 2.0)
            if new_path.size() == 0 or new_path.front() != new_point:
                new_path.push_back(new_point) # only minimum point path
    
    return new_path

func _get_converted_point(point : Vector2) -> Vector2:
    return map_to_world(world_to_map(point)) + (cell_size / 2.0)
