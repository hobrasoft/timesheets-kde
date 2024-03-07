= Timesheet Plasmoid for KDE 5

Plasmoid records the time spent on projects and tasks.

The plasmoid requires a timesheets server running:

- https://github.com/hobrasoft/timesheets-server


== Installation

    git clone https://github.com/hobrasoft/timesheets-kde
    kpackagetool5 -i timesheet-plasmoid.git


If the plasmoid is installed already, use:

    kpackagetool5 -u timesheet-plasmoid.git

The plasmashell should be restarted after upgrading the plasmoid.
You can log-out and log-in again, or restart the plasmashell manually.
Press Alt-F2 it your KDE environment and write to the dialog line:

    kquitapp5 plasmashell; kstart5 plasmashell


