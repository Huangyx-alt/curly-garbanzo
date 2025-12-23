local Command = {};

function Command.Execute(notifyName, view,is_not_destroy_gameobject,playsound)

    if not view then return end;
    if view.Close then
        view:Close(is_not_destroy_gameobject);
    end
    ModelList.ApplicationGuideModel:ChangeViewSortLayer2()
end
return Command;