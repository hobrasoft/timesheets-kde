= Timesheet Plasmoid pro prostředí KDE
Plasmoid pomáhá zaznamenávat práci podle úkolů a projektů

== Instalace

    git clone https://dev.hobrasoft.cz/source/timesheet-plasmoid.git
    kpackagetool5 -i timesheet-plasmoid.git


Pokud už máte plasmoid nainstalovaný a provádíte upgrade, použijte:

    kpackagetool5 -u timesheet-plasmoid.git

Pokud se po upgrade zobrazuje stará verze, je možné se odhlásit/přihlásit, nebo
restartovat kplasmashell (nejlépe přes Alt-F2):

    kquitapp5 plasmashell
    plasmashell


