if SERVER then
    AddCSLuaFile("vgui/main_f4_menu.lua")

    resource.AddFile("materials/clixf4/new.png")
    resource.AddFile("materials/clixf4/shipment.png")

    util.AddNetworkString("f4menu")

    hook.Add("ShowSpare2", "F4MenuHook", function(ply)
        net.Start( "f4menu" )
        net.Send( ply )
    end)

    for _, f in pairs( file.Find( "materials/clixf4/*.png", "GAME" ) ) do
		resource.AddFile( "materials/clixf4/" .. f )
        print("materials/clixf4/" .. f)
    end

    print("Clix's F4 Running!")

end

if CLIENT then
    include("vgui/main_f4_menu.lua")

    net.Receive("f4menu",function()
        if( !MainF4Menu ) then
            MainF4Menu = vgui.Create("main_f4_menu")
            MainF4Menu:SetVisible(false)
        end

        if (MainF4Menu:IsVisible()) then
            MainF4Menu:SetVisible(false)
            gui.EnableScreenClicker(false)
        else
            MainF4Menu:SetVisible(true)
            gui.EnableScreenClicker(true)
        end

  end)

end
