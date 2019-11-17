include("clix_f4_config.lua")


local blur = Material("pp/blurscreen")
local function DrawBlur(panel, amount)
  local x, y = panel:LocalToScreen(0, 0)
  local scrW, scrH = ScrW(), ScrH()
  surface.SetDrawColor(255, 255, 255)
  surface.SetMaterial(blur)
  for i = 1, 5 do
    blur:SetFloat("$blur", (i / 3) * (amount or 6))
    blur:Recompute()
    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
  end
end

local function drawCircl( x, y, radius, ang )
    local cir = {}
    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, (ang/5) do
        local a = math.rad( ( i / (ang/5) ) * -ang +180)
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end
    draw.NoTexture()
    surface.DrawPoly( cir )
end

w = ScrW() * 0.75
h = ScrH() * 0.75

local PANEL = {

    Paint = function(self, w, h)
        DrawBlur(self, 4)
        surface.SetDrawColor(0,0,0,150)
        surface.DrawRect( 0, 0, w, h )
        //outline
        surface.SetDrawColor(0,0,0,175)
        surface.DrawOutlinedRect(0, 0, w, h)
    end,

    Init = function( self )
        self:SetSize(w, h)
        self:Center()
        self:SetVisible(true)

        local x, y = self:GetSize()

        surface.SetFont("DermaLarge")
        local titleX, titleY = surface.GetTextSize("Clix's DarkRP")

        local title = vgui.Create("DLabel", self)
        title:SetText("Clix's DarkRP")
        title:SetSize(titleX, titleY)
        title:SetPos(375, 62.5)
        title:SetFont("DermaLarge")
        title:SetTextColor(config.colors["white"])
        //
        // CLOSE
        //
        local closeButton = vgui.Create("DButton", self)
        closeButton:SetText( "X Close" )
        closeButton:SetSize( 100, 30 )
        closeButton:SetPos( w-110, 10 )
        closeButton:SetTextColor(config.colors["white"])
        closeButton.Paint = function( self, w, h )
            //Set Close box to a matte red
            surface.SetDrawColor(225,50,50,255)
            surface.DrawRect( 0, 0, w, h )
            //Set outline to red-black
            surface.SetDrawColor(150,50,50,255)
            surface.DrawOutlinedRect( 0, 0, w, h )
        end
        closeButton.DoClick = function()
            MainF4Menu:SetVisible(false)
            gui.EnableScreenClicker(false)
        end

        //
        // REFRESH BUTTON
        //
        local refreshButton = vgui.Create("DButton", self)
        refreshButton:SetText( "Refresh" )
        refreshButton:SetSize( 100, 30 )
        refreshButton:SetPos( w-220, 10 )
        refreshButton:SetTextColor(Color(0,0,0,255))
        refreshButton.Paint = function( self, w, h )
            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect( 0, 0, w, h )
            surface.SetDrawColor(50,50,50,255)
            surface.DrawOutlinedRect( 0, 0, w, h )
        end
        refreshButton.DoClick = function()
            gui.EnableScreenClicker(false)
            MainF4Menu:Remove()
            MainF4Menu = vgui.Create("main_f4_menu", PANEL)
            MainF4Menu:SetVisible(false)
        end

        //
        // Player Info
        //

        local playerCard = vgui.Create("DPanel", self)
        playerCard:SetPos( 10, 10 )
        playerCard:SetSize( 350, 125 )
        playerCard.Paint = function( self, w, h )
            surface.SetDrawColor(config.colors["area"])
            surface.DrawRect( 0, 0, w, h )
        end
        local playerCardImage = vgui.Create("AvatarImage", playerCard)
        playerCardImage:SetSize(125, 125)
        playerCardImage:SetPlayer( LocalPlayer(), 128 )

        local usernameX, usernameY = surface.GetTextSize(LocalPlayer():GetName())
        local playerCardUsername = vgui.Create("DLabel", playerCard)
        playerCardUsername:SetPos(135, 10)
        playerCardUsername:SetTextColor(config.colors["white"])
        playerCardUsername:SetFont("DermaLarge")
        playerCardUsername:SetText(LocalPlayer():GetName())
        playerCardUsername:SetSize(usernameX,usernameY)

        local walletX, walletY = surface.GetTextSize(LocalPlayer():getDarkRPVar("money"))
        local playerCardWallet = vgui.Create("DLabel", playerCard)
        playerCardWallet:SetPos(135, 30)
        playerCardWallet:SetTextColor(config.colors["white"])
        playerCardWallet:SetFont("DermaMedium")
        playerCardWallet:SetText("$" .. LocalPlayer():getDarkRPVar("money"))
        playerCardWallet:SetSize(walletX,walletY)

        // Pages
        local pagesBackground = vgui.Create("DPanel", self)
        pagesBackground:SetPos(10,145)
        pagesBackground:SetSize(w-20, h-155)
        pagesBackground.Paint = function(self, w, h)
            surface.SetDrawColor(0,0,0,0)
            surface.DrawRect( 0, 0, w, h )
            surface.SetDrawColor(0,0,0,0)
            surface.DrawOutlinedRect(0, 0, w, h)
        end

        local pages = vgui.Create("MAINColSheet", pagesBackground)
        pages:Dock(FILL)


        //
        // Home Page
        //
        local pageHomeArea = vgui.Create("DPanel", pages)
        pageHomeArea:Dock( FILL )
        pageHomeArea.Paint = function( self, w, h )
            surface.SetDrawColor(config.colors["areaBackground"])
            surface.DrawRect( 0, 0, w, h )
        end
        pages:AddSheet("Home", pageHomeArea, "icon16/house.png")

        local pageHomeBackgroundRight = vgui.Create( "DPanel", pageHomeArea)
        pageHomeBackgroundRight:Dock( RIGHT )
        pageHomeBackgroundRight:SetSize(300, 0)
        pageHomeBackgroundRight:DockMargin(10, 0, 10, 0)
        pageHomeBackgroundRight.Paint = function( self, w, h )
            surface.SetDrawColor(config.colors["area"])
            surface.DrawRect( 0, 0, w, h )
        end


        local pageHomeBackgroundMiddle = vgui.Create("DScrollPanel", pageHomeArea)
        pageHomeBackgroundMiddle:Dock( FILL )
        pageHomeBackgroundMiddle.Paint = function( self, w, h )
            surface.SetDrawColor(config.colors["area"])
            surface.DrawRect( 0, 0, w, h )

            //testing
            surface.SetDrawColor(20,20,20,200)
            drawCircl(90, 90, 80, 360)
            surface.SetDrawColor(25,255,25,255)
            drawCircl(90, 90, 80, ((player.GetCount()*.75)/(game.MaxPlayers()*2)*360))
            draw.SimpleText("Server Population", "DermaMedium", 90, 180, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            //real
            //drawCircl(90, 90, 80, (player.GetCount()/game.MaxPlayers())*360)




        end

        /*
        local gameStats = vgui.Create( "DPanel", pageHomeArea )
        gameStats:Dock(FILL)
    	function gameStats:Paint( w, h )
    		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
    		draw.SimpleText( "More Statistics", "DermaMedium", w / 2, 18, Color( 255, 255, 255, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    	end

    	local gameStatsList = vgui.Create( "DScrollPanel", pageHomeArea )
    	gameStatsList:Dock(FILL)
    	gameStatsList:SetPos( 1, 30 )

        i = 0
        for stat, data in pairs( clix.stats ) do
    		local gameStat = vgui.Create( "DPanel", gameStatsList )
    		gameStat:SetSize( 400, 300 )
    		gameStat:SetPos( 0, 0 + ( 31 * ( i - 1 ) ) )
    		function gameStat:Paint( w, h )
    			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 5 ) )
    			draw.SimpleText( stat, "Derma16", 10, 15, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    			draw.SimpleText( data(), "Derma16", w - 20, 15, Color( 255, 255, 255, 200 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
    		end
    		i = i + 1
    	end
        */
        /*
        local html = vgui.Create( "HTML", pageHomeArea )
        html:Dock( FILL )
        html:OpenURL( "https://www.twitch.tv/clix77" )
        */

        //
        // Jobs Page
        //
        local pageJobArea = vgui.Create("DPanel", pages)
        pageJobArea:Dock( FILL )
        pageJobArea.Paint = function( self, w, h )
            surface.SetDrawColor(config.colors["areaBackground"])
            surface.DrawRect( 0, 0, w, h )
        end
        pages:AddSheet("Jobs", pageJobArea, "icon16/user.png")

        local pageJobRightBackground = vgui.Create( "DPanel", pageJobArea)
        pageJobRightBackground:Dock( RIGHT )
        pageJobRightBackground:SetSize(300, 0)
        pageJobRightBackground:DockMargin(10, 0, 10, 0)
        pageJobRightBackground.Paint = function( self, w, h )
            surface.SetDrawColor(config.colors["area"])
            surface.DrawRect( 0, 0, w, h )
        end

        local pageJobAreaScroll = vgui.Create("DScrollPanel", pageJobArea)
        pageJobAreaScroll:Dock( FILL )
        pageJobAreaScroll.Paint = function( self, w, h )
            surface.SetDrawColor(0,0,0,0)
            surface.DrawRect( 0, 0, w, h )
        end

        local sbar = pageJobAreaScroll:GetVBar()
        function sbar:Paint( w, h ) draw.RoundedBox( 0, 0, 0, w, h, config.colors["scrollBarBackground"] ) end
        function sbar.btnUp:Paint( w, h ) draw.RoundedBox( 0, 0, 0, w, h, config.colors["scrollBarButtons"] ) end
        function sbar.btnDown:Paint( w, h ) draw.RoundedBox( 0, 0, 0, w, h, config.colors["scrollBarButtons"] ) end
        function sbar.btnGrip:Paint( w, h ) draw.RoundedBox( 0, 0, 0, w, h, config.colors["scrollBar"] ) end

        local categories = {}
        for i, v in pairs(DarkRP.getCategories()) do
            if(i == "jobs") then
                for k, e in pairs(v) do
                    if (table.getn(e.members) != 0) then
                        table.insert(categories, e)
                    end
                end
            end
        end

        for k, v in pairs(categories) do

            local pageJobCategory = vgui.Create("MAINCollapseSheet", pageJobAreaScroll)
            pageJobCategory:Dock( TOP )
            pageJobCategory:SetSize(0, 85)
            pageJobCategory:DockMargin(0, 0, 10, 5)
            pageJobCategory:SetLabel(v.name)
            pageJobCategory.lerpHeight = 10
            pageJobCategory.lerpOpacity = 255
            pageJobCategory.Paint = function( self, w, h )
                surface.SetDrawColor(v.color.r, v.color.g, v.color.b, self.lerpOpacity)
                surface.DrawRect( 0, 0, w, 40 )
            end
            /*
            surface.SetFont("DermaMedium")
            local categoryTitle = v.name
            local categoryTitleX, categoryTitleY = surface.GetTextSize(categoryTitle)

            local pageJobCategoryTitle = vgui.Create("DLabel", pageJobAreaScroll)
            pageJobCategoryTitle:SetText(categoryTitle)
            pageJobCategoryTitle:Dock( TOP )
            pageJobCategoryTitle:DockMargin(25, 7.5, 5, 5)
            pageJobCategoryTitle:SetSize(categoryTitleX,categoryTitleY)
            pageJobCategoryTitle:SetFont("DermaMedium")
            pageJobCategoryTitle:SetTextColor(Color(255,255,255))
            */
            //Still need to add it so that v.sortOrder
            //output:3
            //       4
            //       255

            for num, data in pairs(v.members) do
                if (string.lower(LocalPlayer():getDarkRPVar("job")) !=  string.lower(data.name)) then
                    local pageJobBackground = vgui.Create("DPanel", pageJobCategory)
                    pageJobBackground:Dock( TOP )
                    pageJobBackground:SetSize(0, 85)
                    pageJobBackground:DockMargin(0, 0, 10, 5)
                    pageJobBackground.lerpHeight = 10
                    pageJobBackground.lerpOpacity = 255
                    pageJobBackground.Paint = function( self, w, h )
                        surface.SetDrawColor(data.color.r, data.color.g, data.color.b, self.lerpOpacity)
                        surface.DrawRect( 0, h-self.lerpHeight, w, h )
                    end

                    local pageJobIcon = vgui.Create( "DModelPanel", pageJobBackground )
                    pageJobIcon:Dock( LEFT )
                    pageJobIcon:SetSize( 85, 85 )
                    pageJobIcon:SetPos(0,0)
                    pageJobIcon:SetFOV( 50 )
                    pageJobIcon:SetCamPos( Vector( 20, 15, 61 ) )
                    pageJobIcon:SetLookAt( Vector( 0, 0, 61 ) )
                    if type( data.model ) == "table" and table.Count( data.model ) > 1 then
                        pageJobIcon:SetModel( data.model[1] ) -- you can only change colors on playermodels
                    else
                        pageJobIcon:SetModel( data.model ) -- you can only change colors on playermodels
                    end

                    local pageJobDataBackground = vgui.Create( "DPanel", pageJobBackground)
                    pageJobDataBackground:Dock( FILL )
                    pageJobDataBackground:SetSize(0, 125)
                    pageJobDataBackground:DockMargin(5, 0, 0, 10)
                    pageJobDataBackground.lerpOpacity = 150
                    pageJobDataBackground.Paint = function( self, w, h )
                        if self:IsHovered() then
                            pageJobBackground.lerpHeight = Lerp( 0.1, pageJobBackground.lerpHeight, pageJobBackground:GetTall() )
                            pageJobBackground.lerpOpacity = Lerp(0.1, pageJobBackground.lerpOpacity, 150)
                            self.lerpOpacity = Lerp(0.1, self.lerpOpacity, 225)
                        else
                            pageJobBackground.lerpHeight = Lerp( 0.1, pageJobBackground.lerpHeight, 10 )
                            pageJobBackground.lerpOpacity = Lerp(0.1, pageJobBackground.lerpOpacity, 255)
                            self.lerpOpacity = Lerp(0.1, self.lerpOpacity, 150)
                        end

                        surface.SetDrawColor(25, 25, 25, self.lerpOpacity)
                        surface.DrawRect(0, 0, w, h)
                        // w/scrw = width of this garbage in percent.
                        //print(w)
                        //print(ScrW())
                    end

                    function pageJobDataBackground:OnCursorEntered()
                        self:SetCursor( "hand" )
                    end

                    function pageJobDataBackground:OnCursorExited()
                        self:SetCursor( "arrow" )
                    end

                    function pageJobIcon:OnMousePressed()

                        if data.vote then
                            RunConsoleCommand( "say", "/vote" .. data.command )
                        else
                            RunConsoleCommand( "say", "/" .. data.command )
                        end

                        timer.Simple( 0.15, function()
                            gui.EnableScreenClicker(false)
                            MainF4Menu:Remove()
                            MainF4Menu = vgui.Create("main_f4_menu", PANEL)
                            MainF4Menu:SetVisible(false)
                        end )

                    end

                    function pageJobDataBackground:OnMousePressed()

                        if data.vote then
                            RunConsoleCommand( "say", "/vote" .. data.command )
                        else
                            RunConsoleCommand( "say", "/" .. data.command )
                        end

                        timer.Simple( 0.15, function()
                            gui.EnableScreenClicker(false)
                            MainF4Menu:Remove()
                            MainF4Menu = vgui.Create("main_f4_menu", PANEL)
                            MainF4Menu:SetVisible(false)
                        end )

                    end

                    local icon = vgui.Create( "DImage", pageJobDataBackground )
                    icon:SetSize( 16, 16 )
                    icon:SetPos( 5, 10 )
                    icon:SetMaterial( Material( "icon16/user_suit.png" ))
                    icon:SetImageColor( Color( 255, 255, 255, 225 ) )

                    surface.SetFont("DermaMedium")
                    local titleText = data.name
                    local titleX, titleY = surface.GetTextSize(titleText)

                    local pageJobDataTitle = vgui.Create("DLabel", pageJobDataBackground)
                    pageJobDataTitle:SetText(titleText)
                    pageJobDataTitle:Dock( TOP )
                    pageJobDataTitle:DockMargin(25, 7.5, 5, 5)
                    pageJobDataTitle:SetSize(titleX,titleY)
                    pageJobDataTitle:SetFont("DermaMedium")
                    pageJobDataTitle:SetTextColor(config.colors["white"])

                    //if v.hasLicense then
                    if true then
                        surface.SetFont("Derma16")
                        local text = string.format("$%s", data.salary )
                        local textX, textY = surface.GetTextSize(text)
                        local salaryText = vgui.Create("DLabel", pageJobDataBackground)
                        salaryText:SetText(text)
                        salaryText:DockMargin(5, 5, 5, 5)
                        salaryText:SetSize(textX,textY)
                        salaryText:SetPos(25, 35)
                        salaryText:SetFont("Derma16")
                        salaryText:SetTextColor(config.colors["white"])

                    	local icon = vgui.Create( "DImage", pageJobDataBackground )
            			icon:SetSize( 16, 16 )
            			icon:SetPos( 5, 35 )
            			icon:SetMaterial( Material( "icon16/money.png" ))
            			icon:SetImageColor( Color( 255, 255, 255, 225 ) )
            		end
                    if(data.new) then
                        local icon = vgui.Create( "DImage", pageJobDataBackground )
                        icon:SetSize( 64, 64 )
            			icon:SetPos( (ScrW() * 0.34125)-(icon:GetWide()/6), (pageJobDataBackground:GetTall()/2)-(icon:GetTall()*.9) )
            			icon:SetMaterial( Material( "clixf4/new.png" ))
            			icon:SetImageColor( Color( 255, 255, 255, 200 ) )
                    end
                end
            end
        end

        /*
        for k, v in pairs( RPExtraTeams ) do
            if (string.lower(LocalPlayer():getDarkRPVar("job")) !=  string.lower(v.name)) then
                local pageJobBackground = vgui.Create("DPanel", pageJobAreaScroll)
                pageJobBackground:Dock( TOP )
                pageJobBackground:SetSize(0, 85)
                pageJobBackground:DockMargin(0, 0, 10, 5)

                //pageJobBackground.hoverColorR = 0
                //pageJobBackground.hoverColorG = 0
                //pageJobBackground.hoverColorB = 0
                //pageJobBackground.hoverColorA = 0

                pageJobBackground.lerpHeight = 10
                pageJobBackground.lerpOpacity = 255
                pageJobBackground.Paint = function( self, w, h )

                    //if self:IsHovered() then
                    //    self.hoverColorR = Lerp( 0.1, self.hoverColorR, v.color.r )
                    //    self.hoverColorG = Lerp( 0.1, self.hoverColorG, v.color.g)
                    //    self.hoverColorB = Lerp( 0.1, self.hoverColorB, v.color.b )
                    //    self.hoverColorA = Lerp( 0.1, self.hoverColorA, 255 )
                    //else
                    //    self.hoverColorR = Lerp( 0.1, self.hoverColorR, 0 )
                    //    self.hoverColorG = Lerp( 0.1, self.hoverColorG, 0 )
                    //    self.hoverColorB = Lerp( 0.1, self.hoverColorB, 0 )
                    //    self.hoverColorA = Lerp( 0.1, self.hoverColorA, 0 )
                    //end
                    //surface.SetDrawColor(self.hoverColorR, self.hoverColorG, self.hoverColorB, 75)

                    surface.SetDrawColor(v.color.r, v.color.g, v.color.b, self.lerpOpacity)

                    surface.DrawRect( 0, h-self.lerpHeight, w, h )
                end



                local pageJobIcon = vgui.Create( "DModelPanel", pageJobBackground )
                pageJobIcon:Dock( LEFT )
                pageJobIcon:SetSize( 85, 85 )
                pageJobIcon:SetPos(0,0)
                pageJobIcon:SetFOV( 50 )
                pageJobIcon:SetCamPos( Vector( 20, 15, 61 ) )
                pageJobIcon:SetLookAt( Vector( 0, 0, 61 ) )
                if type( v.model ) == "table" and table.Count( v.model ) > 1 then
                    pageJobIcon:SetModel( v.model[1] ) -- you can only change colors on playermodels
                else
                    pageJobIcon:SetModel( v.model ) -- you can only change colors on playermodels
                end


                local pageJobDataBackground = vgui.Create( "DPanel", pageJobBackground)
                pageJobDataBackground:Dock( FILL )
                pageJobDataBackground:SetSize(0, 125)
                pageJobDataBackground:DockMargin(5, 0, 0, 10)
                pageJobDataBackground.lerpOpacity = 150
                pageJobDataBackground.Paint = function( self, w, h )
                    if self:IsHovered() then
                        pageJobBackground.lerpHeight = Lerp( 0.1, pageJobBackground.lerpHeight, pageJobBackground:GetTall() )
                        pageJobBackground.lerpOpacity = Lerp(0.1, pageJobBackground.lerpOpacity, 150)
                        self.lerpOpacity = Lerp(0.1, self.lerpOpacity, 225)
                    else
                        pageJobBackground.lerpHeight = Lerp( 0.1, pageJobBackground.lerpHeight, 10 )
                        pageJobBackground.lerpOpacity = Lerp(0.1, pageJobBackground.lerpOpacity, 255)
                        self.lerpOpacity = Lerp(0.1, self.lerpOpacity, 150)
                    end

                    surface.SetDrawColor(25, 25, 25, self.lerpOpacity)
                    surface.DrawRect(0, 0, w, h)
                    // w/scrw = width of this garbage in percent.
                    //print(w)
                    //print(ScrW())
                end

                function pageJobDataBackground:OnCursorEntered()
                    self:SetCursor( "hand" )
                end

                function pageJobDataBackground:OnCursorExited()
                    self:SetCursor( "arrow" )
                end

                function pageJobIcon:OnMousePressed()
                    if v.vote then
                        RunConsoleCommand( "say", "/vote" .. v.command )
                    else
                        RunConsoleCommand( "say", "/" .. v.command )
                    end

                    timer.Simple( 0.15, function()
                        gui.EnableScreenClicker(false)
                        MainF4Menu:Remove()
                        MainF4Menu = vgui.Create("main_f4_menu", PANEL)
                        MainF4Menu:SetVisible(false)
                    end )
                end

                function pageJobDataBackground:OnMousePressed()
                    if v.vote then
                        RunConsoleCommand( "say", "/vote" .. v.command )
                    else
                        RunConsoleCommand( "say", "/" .. v.command )
                    end

                    timer.Simple( 0.15, function()
                        gui.EnableScreenClicker(false)
                        MainF4Menu:Remove()
                        MainF4Menu = vgui.Create("main_f4_menu", PANEL)
                        MainF4Menu:SetVisible(false)
                    end )
                end

                local icon = vgui.Create( "DImage", pageJobDataBackground )
                icon:SetSize( 16, 16 )
                icon:SetPos( 5, 10 )
                icon:SetMaterial( Material( "icon16/user_suit.png" ))
                icon:SetImageColor( Color( 255, 255, 255, 225 ) )

                surface.SetFont("DermaMedium")
                local titleText = v.name
                local titleX, titleY = surface.GetTextSize(titleText)

                local pageJobDataTitle = vgui.Create("DLabel", pageJobDataBackground)
                pageJobDataTitle:SetText(titleText)
                pageJobDataTitle:Dock( TOP )
                pageJobDataTitle:DockMargin(25, 7.5, 5, 5)
                pageJobDataTitle:SetSize(titleX,titleY)
                pageJobDataTitle:SetFont("DermaMedium")
                pageJobDataTitle:SetTextColor(Color(255,255,255))
                local icons = 0
                //if v.hasLicense then
                if true then
                    surface.SetFont("Derma16")
                    local text = string.format("$%s", v.salary )
                    local textX, textY = surface.GetTextSize(text)
                    local salaryText = vgui.Create("DLabel", pageJobDataBackground)
                    salaryText:SetText(text)
                    salaryText:DockMargin(5, 5, 5, 5)
                    salaryText:SetSize(textX,textY)
                    salaryText:SetPos(25, 35)
                    salaryText:SetFont("Derma16")
                    salaryText:SetTextColor(Color(255,255,255))

                	local icon = vgui.Create( "DImage", pageJobDataBackground )
        			icon:SetSize( 16, 16 )
        			icon:SetPos( 5, 35 )
        			icon:SetMaterial( Material( "icon16/money.png" ))
        			icon:SetImageColor( Color( 255, 255, 255, 225 ) )
        			icons = icons + 1
        		end
                if(v.new) then
                    local icon = vgui.Create( "DImage", pageJobDataBackground )
                    icon:SetSize( 56, 56 )
        			icon:SetPos( (ScrW() * 0.34125) - 66, (pageJobDataBackground:GetTall()/2)-54 )
        			icon:SetMaterial( Material( "clixf4/new.png" ))
        			icon:SetImageColor( Color( 255, 255, 255, 200 ) )
        			icons = icons + 1
                end
            end
        end
        */


        local pageShopArea = vgui.Create("DPanel", pages)
        pageShopArea:Dock( FILL )
        pageShopArea.Paint = function( self, w, h )
            surface.SetDrawColor(config.colors["areaBackground"])
            surface.DrawRect( 0, 0, w, h )
        end
        pages:AddSheet("Shop", pageShopArea, "icon16/basket.png")

        local pageShopRightBackground = vgui.Create( "DPanel", pageShopArea)
        pageShopRightBackground:Dock( RIGHT )
        pageShopRightBackground:SetSize(300, 0)
        pageShopRightBackground:DockMargin(10, 0, 10, 0)
        pageShopRightBackground.Paint = function( self, w, h )
            surface.SetDrawColor(config.colors["area"])
            surface.DrawRect( 0, 0, w, h )
        end

        local pageShopAreaScroll = vgui.Create("DScrollPanel", pageShopArea)
        pageShopAreaScroll:Dock( FILL )
        pageShopAreaScroll.Paint = function( self, w, h )
            surface.SetDrawColor(0,0,0,0)
            surface.DrawRect( 0, 0, w, h )
        end

        local shopbar = pageShopAreaScroll:GetVBar()
        function shopbar:Paint( w, h ) draw.RoundedBox( 0, 0, 0, w, h, config.colors["scrollBarBackground"] ) end
        function shopbar.btnUp:Paint( w, h ) draw.RoundedBox( 0, 0, 0, w, h, config.colors["scrollBarButtons"] ) end
        function shopbar.btnDown:Paint( w, h ) draw.RoundedBox( 0, 0, 0, w, h, config.colors["scrollBarButtons"] ) end
        function shopbar.btnGrip:Paint( w, h ) draw.RoundedBox( 0, 0, 0, w, h, config.colors["scrollBar"] ) end

        for k, v in pairs( DarkRPEntities ) do
            //if (string.lower(LocalPlayer():getDarkRPVar("job")) !=  string.lower(v.name)) then
            if not v.allowed or ( type( v.allowed) == "table" and table.HasValue( v.allowed, LocalPlayer():Team() ) ) then
                local pageShopBackground = vgui.Create("DPanel", pageShopAreaScroll)
                pageShopBackground:Dock( TOP )
                pageShopBackground:SetSize(0, 85)
                pageShopBackground:DockMargin(0, 0, 10, 5)
                pageShopBackground.Paint = function( self, w, h )
                    surface.SetDrawColor(config.colors["area"])
                    surface.DrawRect( 0, 0, w, h )
                end

                local pageShopIcon = vgui.Create( "DModelPanel", pageShopBackground )
                pageShopIcon:Dock( LEFT )
                pageShopIcon:SetSize( 85, 85 )
                pageShopIcon:SetPos(0,0)
                pageShopIcon:SetFOV( 40 )

                if type( v.model ) == "table" and table.Count( v.model ) > 1 then
                    pageShopIcon:SetModel( v.model[1] ) -- you can only change colors on playermodels
                else
                    pageShopIcon:SetModel( v.model ) -- you can only change colors on playermodels
                end

                local mn, mx = pageShopIcon.Entity:GetRenderBounds()
        		local size = 0
        		size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
        		size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
        		size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
        		pageShopIcon:SetFOV( 50 )
        		pageShopIcon:SetCamPos( Vector( size, size, size ) )
        		pageShopIcon:SetLookAt( ( mn + mx ) * 0.5 )



                local pageShopDataBackground = vgui.Create( "DPanel", pageShopBackground)
                pageShopDataBackground:Dock( FILL )
                pageShopDataBackground:SetSize(0, 125)
                pageShopDataBackground:DockMargin(5, 5, 5, 5)
                pageShopDataBackground.hoverColor = 0

                pageShopDataBackground.Paint = function( self, w, h )

                    if self:IsHovered() then
                        self.hoverColor = Lerp( 0.1, self.hoverColor, 75 )
                    else
                        self.hoverColor = Lerp( 0.1, self.hoverColor, 0 )
                    end

                    surface.SetDrawColor(self.hoverColor, self.hoverColor, self.hoverColor, 75)
                    surface.DrawRect(0, 0, w, h)

                    surface.SetDrawColor( Color( 255, 255, 255, 225 ) )

        			surface.SetMaterial( Material("icon16/money.png" ) )
        			surface.DrawTexturedRect( 5, 30, 16, 16 )

        			surface.SetMaterial( Material("icon16/user_green.png" ) )
        			surface.DrawTexturedRect( 5, 50, 16, 16 )

        			draw.SimpleText( "$" .. v.price, "Derma16", 30, 30, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        			draw.SimpleText( v.max, "Derma16", 30, 50, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                end

                function pageShopDataBackground:OnCursorEntered() self:SetCursor( "hand" ) end
                function pageShopDataBackground:OnCursorExited() self:SetCursor( "arrow" ) end
                function pageShopIcon:OnMousePressed()
                    //Find a way to limit these presses
                    //Open a desc tab on the right?
                    RunConsoleCommand( "say", "/" .. v.cmd )

                end
                function pageShopDataBackground:OnMousePressed()
                    //Find a way to limit these presses
                    //Open a desc tab on the right?
                    RunConsoleCommand( "say", "/" .. v.cmd )
                end

                surface.SetFont("DermaMedium")
                local titleText = v.name
                local titleX, titleY = surface.GetTextSize(titleText)

                local pageShopDataTitle = vgui.Create("DLabel", pageShopDataBackground)
                pageShopDataTitle:SetText(titleText)
                pageShopDataTitle:Dock( TOP )
                pageShopDataTitle:DockMargin(5, 5, 5, 5)
                pageShopDataTitle:SetSize(titleX,titleY)
                pageShopDataTitle:SetFont("DermaMedium")
                pageShopDataTitle:SetTextColor(config.colors["white"])
                pageShopDataTitle.Paint = function( self)

                end

            end
        end

        local pageShipmentArea = vgui.Create("DPanel", pages)
        pageShipmentArea:Dock( FILL )
        pageShipmentArea.Paint = function( self, w, h )
            surface.SetDrawColor(config.colors["areaBackground"])
            surface.DrawRect( 0, 0, w, h )
        end
        pages:AddSheet("Shipments", pageShipmentArea, "icon16/box.png")

        local pageShipmentRightBackground = vgui.Create( "DPanel", pageShipmentArea)
        pageShipmentRightBackground:Dock( RIGHT )
        pageShipmentRightBackground:SetSize(300, 0)
        pageShipmentRightBackground:DockMargin(10, 0, 10, 0)
        pageShipmentRightBackground.Paint = function( self, w, h )
            surface.SetDrawColor(config.colors["area"])
            surface.DrawRect( 0, 0, w, h )
        end

        local pageShipmentAreaScroll = vgui.Create("DScrollPanel", pageShipmentArea)
        pageShipmentAreaScroll:Dock( FILL )
        pageShipmentAreaScroll.Paint = function( self, w, h )
            surface.SetDrawColor(0,0,0,0)
            surface.DrawRect( 0, 0, w, h )
        end

        local shipbar = pageShipmentAreaScroll:GetVBar()
        function shipbar:Paint( w, h ) draw.RoundedBox( 0, 0, 0, w, h, config.colors["scrollBarBackground"] ) end
        function shipbar.btnUp:Paint( w, h ) draw.RoundedBox( 0, 0, 0, w, h, config.colors["scrollBarButtons"] ) end
        function shipbar.btnDown:Paint( w, h ) draw.RoundedBox( 0, 0, 0, w, h, config.colors["scrollBarButtons"] ) end
        function shipbar.btnGrip:Paint( w, h ) draw.RoundedBox( 0, 0, 0, w, h, config.colors["scrollBar"] ) end

        local shipments = {}
        local singles = {}
        for i, data in pairs ( CustomShipments ) do
            if not data.allowed or ( type( data.allowed) == "table" and table.HasValue( data.allowed, LocalPlayer():Team() ) ) then
                if data.seperate then
                    table.insert( singles, data )
                end
                if !data.noship then
                    table.insert( shipments, data )
                end
            end
        end

        for k, v in pairs( CustomShipments ) do
            //if (string.lower(LocalPlayer():getDarkRPVar("job")) !=  string.lower(v.name)) then
            if not v.allowed or ( type( v.allowed) == "table" and table.HasValue( v.allowed, LocalPlayer():Team() ) ) then
                local pageShipmentBackground = vgui.Create("DPanel", pageShipmentAreaScroll)
                pageShipmentBackground:Dock( TOP )
                pageShipmentBackground:SetSize(0, 85)
                pageShipmentBackground:DockMargin(0, 0, 10, 5)
                pageShipmentBackground.Paint = function( self, w, h )
                    surface.SetDrawColor(config.colors["area"])
                    surface.DrawRect( 0, 0, w, h )
                end

                image = ("vgui/hud/" .. v.entity)

                local pageShipmentIcon = vgui.Create( "DModelPanel", pageShipmentBackground )
                pageShipmentIcon:Dock( LEFT )
                pageShipmentIcon:SetSize( 85, 85 )
                pageShipmentIcon:SetPos(0,0)
                pageShipmentIcon:SetFOV( 40 )
                if (v.model == "") then
                    pageShipmentIcon:SetModel( "models/items/item_item_crate_dynamic.mdl" )

                    print("error with the model")
                else
                    pageShipmentIcon:SetModel( v.model )
                end

                local mn, mx = pageShipmentIcon.Entity:GetRenderBounds()
                local sizex, sizey, sizez = 0
                sizex = math.max(math.abs(mn.x), math.abs(mx.x) )
                sizey = math.max(math.abs(mn.y), math.abs(mx.y) )
                sizez = math.max(math.abs(mn.z), math.abs(mx.z) )

                pageShipmentIcon:SetFOV( 35 * (pageShipmentIcon.Entity:GetModelScale()) )
                pageShipmentIcon:SetCamPos( Vector( sizex, sizey, sizez ) )
        		pageShipmentIcon:SetLookAt( ( mn + mx ) * 0.5 )


                /*
                local pageShipmentIcon = vgui.Create( "DImage", pageShipmentBackground )
                pageShipmentIcon:Dock( LEFT )
                pageShipmentIcon:SetSize( 85, 85 )
                pageShipmentIcon:SetPos(0,0)
                pageShipmentIcon:SetImage( "vgui/hud/" .. v.entity )
                */





                local pageShipmentDataBackground = vgui.Create( "DPanel", pageShipmentBackground)
                pageShipmentDataBackground:Dock( FILL )
                pageShipmentDataBackground:SetSize(0, 125)
                pageShipmentDataBackground:DockMargin(5, 5, 5, 5)
                pageShipmentDataBackground.hoverColor = 0

                pageShipmentDataBackground.Paint = function( self, w, h )

                    if self:IsHovered() then
                        self.hoverColor = Lerp( 0.1, self.hoverColor, 75 )
                    else
                        self.hoverColor = Lerp( 0.1, self.hoverColor, 0 )
                    end

                    surface.SetDrawColor(self.hoverColor, self.hoverColor, self.hoverColor, 75)
                    surface.DrawRect(0, 0, w, h)

                    surface.SetDrawColor( Color( 255, 255, 255, 125 ) )

                    surface.SetMaterial( Material("icon16/money.png" ) )
                    surface.DrawTexturedRect( 5, 30, 16, 16 )

                    surface.SetMaterial( Material("icon16/user_green.png" ) )
                    surface.DrawTexturedRect( 5, 50, 16, 16 )

                    draw.SimpleText( "$" .. v.price, "Derma16", 30, 30, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                    draw.SimpleText( v.category, "Derma16", 30, 50, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                end

                function pageShipmentDataBackground:OnCursorEntered() self:SetCursor( "hand" ) end
                function pageShipmentDataBackground:OnCursorExited() self:SetCursor( "arrow" ) end
                function pageShipmentIcon:OnMousePressed()
                    //Find a way to limit these presses
                    //Open a desc tab on the right?
                    RunConsoleCommand( "say", "/buyshipment " .. v.name )

                end
                function pageShipmentDataBackground:OnMousePressed()
                    //Find a way to limit these presses
                    //Open a desc tab on the right?
                    RunConsoleCommand( "say", "/buyshipment " .. v.name )
                end

                surface.SetFont("DermaMedium")
                local titleText = v.name
                local titleX, titleY = surface.GetTextSize(titleText)

                local pageShipmentDataTitle = vgui.Create("DLabel", pageShipmentDataBackground)
                pageShipmentDataTitle:SetText(titleText)
                pageShipmentDataTitle:Dock( TOP )
                pageShipmentDataTitle:DockMargin(5, 5, 5, 5)
                pageShipmentDataTitle:SetSize(titleX,titleY)
                pageShipmentDataTitle:SetFont("DermaMedium")
                pageShipmentDataTitle:SetTextColor(config.colors["white"])
                pageShipmentDataTitle.Paint = function( self)
                end

                local icon = vgui.Create( "DImage", pageShipmentDataBackground )
                icon:SetSize( 120, 120 )
    			icon:SetPos( (ScrW() * 0.34125) - 66, -25 )
    			icon:SetMaterial( Material( "clixf4/shipment.png" ))
    			icon:SetImageColor( Color( 255, 255, 255, 200 ) )
            end

        end

        local pageCommandsArea = vgui.Create("DPanel", pages)
        pageCommandsArea:Dock( FILL )
        pageCommandsArea.Paint = function( self, w, h )
            surface.SetDrawColor(config.colors["areaBackground"])
            surface.DrawRect( 0, 0, w, h )
        end
        pages:AddSheet("Commands", pageCommandsArea, "icon16/application_xp_terminal.png")

    end
}

vgui.Register("main_f4_menu", PANEL)
