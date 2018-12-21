main()
{
    level onPlayerConnected();
}
 
onPlayerConnected()
{
    self endon("intermission");
   
    while(1)
    {
        self waittill("connected", peep);
       
            peep thread onSpawnedPlayer();
    }
}
 
onSpawnedPlayer()
{
    self endon("intermission");

    self endon("disconnect");
   
    self waittill("spawned_player");

    self thread whenPlayerSpawns();
}

whenPlayerSpawns()
{
    self thread doCounter();
}

killDeathRatioHud(ratio)
{
    self endon("disconnect");
    self.kdcounter = newClientHudElem(self);
    self.kdcounter.archived = false;
    self.kdcounter.x = 0;
    self.kdcounter.y = 0;
    self.kdcounter.alignX = "left";
    self.kdcounter.alignY = "bottom";
    self.kdcounter.horzAlign = "left";
    self.kdcounter.vertAlign = "bottom";
    self.kdcounter.sort = 1; // force to draw after the bars
    self.kdcounter.font = "default";
    self.kdcounter.fontscale = 1.4;
    self.kdcounter.foreground = true;
    self.kdcounter.alpha = 1;
    self.kdcounter setText("^2K/D: ^1"+ ratio);
}

killDeathCalculate(kills, deaths)
{
    self endon("disconnect");
    if(kills == 0 && deaths == 0)
    {
        ratio = 0;
        self.kdcounter setText("^2K/D: ^1"+ ratio);
    }
    else if(kills >= 1 && deaths == 0)
    {
        ratio = kills;
        self.kdcounter setText("^2K/D: ^1"+ ratio);
    }
    else if(kills == 0 && deaths >= 1)
    {
        ratio = 0;
        self.kdcounter setText("^2K/D: ^1"+ ratio);
    }
    else
    {
        ratio = kills / deaths;
        ratio = int(ratio * 100 + 0.5) / 100;
        self.kdcounter setText("^2K/D: ^1"+ ratio);
    }
}

doCounter()
{
    self endon("disconnect");
    self endon("intermission");
    self thread killDeathRatioHud(0);
    kills = 0;
    deaths = 0;

    while(1)
    {
        if(self.sessionstate == "spectator")
        {
            self.kdcounter.alpha = 0;
            self waittill("spawned_player");
            self.kdcounter.alpha = 1;
        }

        if(kills != self.kills || deaths != self.deaths)
        {
            kills = self.kills;
            deaths = self.deaths;
            self thread killDeathCalculate(kills, deaths);
        }
        wait .2;
    }
}