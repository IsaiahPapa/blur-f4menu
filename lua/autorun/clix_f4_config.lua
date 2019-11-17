config = {}

config.panel = {}
config.panel["primary"] = "test"

config.colors = {}
config.colors["white"]          = Color(255, 255, 255, 255)
config.colors["areaBackground"] = Color(0, 0, 0, 0)
config.colors["area"]           = Color(0, 0, 0, 140)

config.colors["scrollBar"]           = Color( 175, 175, 175 )
config.colors["scrollBarBackground"] = Color( 75, 75, 75, 200 )
config.colors["scrollBarButtons"]    = Color( 25, 25, 25 )


config.frontPage = {}
config.frontPage[ "Server Name" ] = function() return GetHostName() end
config.frontPage[ "Players Online:" ] = function() return #player.GetAll() .. " / " .. game.MaxPlayers() end
config.frontPage[ "Map:" ] = function() return game.GetMap() end
config.frontPage[ "Local Time: " ] = function() return os.date( "%H:%M:%S", RealTime() ) end
config.frontPage[ "Prop Count: " ] = function() return #ents.FindByClass( "prop_physics" ) end
