LIP = dofile("./LIP.lua")

function init(plugin)
    local configuration_path = app.fs.userConfigPath .. "resize-clipboard-image.ini"

    local function file_exists(name)
        local f = io.open(name, "r")

        if f ~= nil then
            io.close(f)
            return true
        else
            return false
        end
    end

    local function resize_clipboard_image(dlg)
        local sprite = app.activeSprite
        local pixel_size = tonumber(dlg.data.size)
        local original_image = sprite.layers[1]:cel(1).image

        if (original_image.width % pixel_size == 0 and original_image.height % pixel_size == 0) then
            local resizedLayer = sprite:newLayer()
            resizedLayer.name = "Layer Resized"
            sprite:newCel(resizedLayer, 1)
    
            local resizedImage = resizedLayer:cel(1).image
    
            for x = 0, original_image.width - 1, 1
            do
                for y = 0, original_image.height - 1, 1
                do
                    if (x % pixel_size == 0) and (y % pixel_size == 0) then
                        local newX = x / pixel_size
                        local newY = y / pixel_size
    
                        resizedImage:drawPixel(newX, newY, original_image:getPixel(x, y))
                    end
                end
            end
    
            sprite:deleteLayer("Layer 1")
    
            app.command.AutocropSprite { }
            app.command.ShowPixelGrid { }
            app.command.FitScreen { }
            app.useTool { tool = "rectangular_marquee", selection = SelectionMode.REPLACE }

            LIP.save(configuration_path, {
                general = {
                    pixel_size = dlg.data.size
                }
            })
        else
            app.alert("The image can't be resized with this pixel size.")
        end
    
        app.refresh()
    end

    local function open_clipboard_image()
        app.command.NewFile {
            ui = true,
            colorMode = ColorMode.RGB,
            fromClipboard = true
        }

        local configuration = nil
        local sprite = app.activeSprite
        local pixel_size = "2"

        if file_exists(configuration_path) then
            configuration = LIP.load(configuration_path)
        end

        if (configuration ~= nil and configuration.general ~= nil and configuration.general.pixel_size ~= nil) then
            pixel_size = configuration.general.pixel_size
        end

        local dlg = Dialog { title = "Pixel Size" }
        dlg:separator { text = "Pixel properties" }
        dlg:entry { id = "size", label = "Size", text = tostring(pixel_size) }
        dlg:newrow()
        dlg:button { id = "cancel", text = "Cancel" }
        dlg:button { id = "ok", text = "OK", focus = true,
            onclick = function()
                resize_clipboard_image(dlg)
                dlg:close()
            end
        }

        if sprite then
            app.command.ShowPixelGrid { }
            app.command.Zoom { percentage = 800, action = "in", focus = "center" }
            dlg:show()
        else
            app.alert("There is no valid image on clipboard.")
            dlg:close()
        end

        app.refresh()
    end

    plugin:newCommand { id = "resize_clipboard_image", title = "Resize Clipboard Image", group = "sprite_size",
        onclick = function()
            open_clipboard_image()
        end
    }

end
