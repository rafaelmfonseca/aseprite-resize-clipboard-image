function init(plugin)

    function ResizePixel()
        app.command.NewFile {
            ui = true,
            colorMode = ColorMode.RGB,
            fromClipboard = true
        }

        local sprite = app.activeSprite

        if sprite then
            app.command.ShowPixelGrid { }
            app.command.Zoom { percentage = 800, action = "in", focus = "center" }
        else
            app.alert("There is no valid image on clipboard.")
        end

        app.refresh()
    end

    plugin:newCommand {
        id = "PixelSize",
        title = "Pixel Size",
        group = "sprite_size",
        onclick = function()
            ResizePixel()
        end
    }

end
