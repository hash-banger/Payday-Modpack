local MenuManagerdo_clear_progress = MenuManager.do_clear_progress

function MenuManager:do_clear_progress()
    managers.achievment:clear_all_steam()
    managers.statistics:reset()
    MenuManagerdo_clear_progress(self)
end
