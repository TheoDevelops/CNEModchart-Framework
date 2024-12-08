function onEvent(eventEvent) {
    if (eventEvent.event.name == "Change ScrollSpeed") {
            scrollSpeed = eventEvent.event.params[0];
    }
}