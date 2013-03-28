Dan Reife
Notes
=====

Implemented editing and deleting notes.

The trash can in the TableView toggles between "Viewing Mode" and "Delete Mode" and an alert displays to inform the reader which s/he is in.

While in Delete Mode, selecting a note deletes it from the table and from CoreData.

In Viewing Mode, selecting a note shows its details. If location services were enabled and authorized when the note was created, the map is displayed. The title of the note is immutable and is displayed as the title of the detail view. Editing the text in the detail view changes it in CoreData as well.

My simulator wouldn't allow me to set the authorization status of my Notes app so I could never actually test that part but I used a lot of the same code from my Location app so I hope it works.

The notes are sorted in alphabetical order of the title.