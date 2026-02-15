# pixelfive-newlife

NewLife systeem voor FiveM servers met ESX en OX integration. Ondersteunt zowel burgers als politie. Spelers kunnen respawnen via een menu met vooraf ingestelde locaties. Het script bevat veiligheidschecks om exploits te voorkomen.

## Features

- Burger en Politie NewLife menu
- Teleport naar vooraf ingestelde locaties
- Inventory reset voor burgers indien gewenst
- Veiligheidschecks tegen spam en manipulatie
- Server-side kicks bij verdachte acties: "Deflopper is je te slim af!"
- Configurable via `shared/config.lua`
- OX_lib contextmenu ondersteuning

## Installatie

1. Plaats de map `pixelfive-newlife` in je `resources` folder
2. Voeg toe aan `server.cfg`:
   ```txt
   ensure pixelfive-newlife
