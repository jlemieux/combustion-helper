-- translation notice : don't change the keys of tables or it won't work anymore (the text within the [ ]), the color coding part mustn't be changed either (|cff00ffff and |r).

-------------------------------
-- table for chat report settings, no problem changing the text lenght as it's outputted to chat frame
CombuLocFR = {["lockon"] = "|cff00ffffCombustionHelper verrouillé|r",
			["lockoff"] = "|cff00ffffCombustionHelper deverrouillé|r",
			["reporton"] = "|cff00ffffRapport de configuration de CombustionHelper activé|r",
			["ffbon"] = "|cff00ffffMode Eclair de givrefeu activé|r",
			["ffboff"] = "|cff00ffffMode Eclair de givrefeu désactivé|r",
			["dmgreporton"] = "|cff00ffffMode rapport de dégats activé|r",
			["dmgreportoff"] = "|cff00ffffMode rapport de dégats désactivé|r",
			["doton"] = "|cff00ffffTimer de dot de Combustion activé|r",
			["dotoff"] = "|cff00ffffTimer de dot de Combustion désactivé|r",	
			["lbon"] = "|cff00ffffMode Bombe Vivante anticipée/ratée activé|r",
			["lboff"] = "|cff00ffffMode Bombe Vivante anticipée/ratée désactivé|r",
			["pyroon"] = "|cff00ffffRapport d'utilisation d'Explosion Pyrotechnique activé|r",
			["pyrooff"] = "|cff00ffffRapport d'utilisation d'Explosion Pyrotechnique désactivé|r",
			["impacton"] = "|cff00ffffMode Impact activé|r",
			["impactoff"] = "|cff00ffffMode Impact désactivé|r",
			["baron"] = "|cff00ffffMode barres de timer activé|r",
			["baroff"] = "|cff00ffffMode barres de timer désactivé|r",
			["criton"] = "|cff00ffffMoniteur de Masse Critique activé|r",
			["critoff"] = "|cff00ffffMoniteur de Masse Critique désactivé|r",
			["ignpredon"] = "|cff00ffffPrédiction de l'Enflammer activé|r",
			["ignpredoff"] = "|cff00ffffPrédiction de l'Enflammer désactivé|r",
			["fson"] = "|cff00ffffMoniteur de Choc de Flammes activé|r",
			["fsoff"] = "|cff00ffffMoniteur de Choc de Flammes désactivé|r",
			["munchon"] = "|cff00ffffRapport de bug d'Enflammer activé|r",
			["munchoff"] = "|cff00ffffRapport de bug d'Enflammer désactivé|r",
			["lbtrackon"] = "|cff00ffffMoniteur de Bombe Vivante activé|r",
			["lbtrackoff"] = "|cff00ffffMoniteur de Bombe Vivante désactivé|r",
			["reset"] = "|cff00ffffLa configuration de CombustionHelper a été réinitialisée.|r",
			["ffbglyphon"] = "|cff00ffffGlyphe d'Eclair de Givrefeu detecté, mode EdG activé.|r",
			["ffbglyphoff"] = "|cff00ffffPas de glyphe d'Eclair de Givrefeu detecté, mode EdG désactivé.|r",
			["autohidemess"] = "|cff00ffffCombustion Helper de retour dans %d secondes.|r",
			["startup"] = "|cff00ffffCombustion Helper est chargé. Interface -> Addons pour la config.|r",
			["combuon"] = "|cff00ffffPas de sort de Combustion dans le livre des sorts, CombustionHelper en cours de masquage.|r",
			["combuoff"] = "|cff00ffffSort de Combustion présent dans le livre des sorts, CombustionHelper de retour.|r",
			["lbrefresh"] = "|cffff0000 -- Vous avez rafraichi votre Bombe Vivante sur |cffffffff%s |cffff0000trop tôt. --|r",
			["lbmiss"] = "|cffff00ff -- La Bombe Vivante lancée sur |cffffffff%s |cffff00ffa raté !! --",
			["pyrorefresh"] = "|cffff0000 -- Vous venez de gâcher une Chaleur Continue, elle fut rafraichie avant utilisation. --|r",
            ["ignrep"] = "|cffff0000 -- Enflammer attendu : |cffffffff%d |cffff0000- appliqué : |cffffffff%d |cffff0000- perdu : |cffffffff%s |cffff0000--|r",
			["lbreport"] = "|cffff0000 -- Bombes Vivantes anticipées pour ce combat : |cffffffff%d |cffff0000--|r",
			["pyroreport"] = "|cffff0000 -- Chaleurs Continues gagnées : |cffffffff%d  |cffff0000- Chaleurs Continues lancées : |cffffffff%d  / %d%% |cffff0000--|r",
			["slashcomm"] = "|cff00ffffOuverture du panneau de configuration de CombustionHelper.|r",
			["comburepthres"] = "|cff00ffffSeuil de rapport d'Enflammer fixé à : %.0f points de dégats.|r",
			["ignadjvalue"] = "|cff00ffffAjustement du timer d'Enflammer fixé à : %.1f secs.|r",
			["redzonetimer"] = "|cff00ffffZone d'alerte des barres de timers fixée à : %.1f secs.|r",
			["interfaceGraph"] = "Options Graphiques",
			["combureport1"] = "|cffff0000 -- Total Combustion : |cffffffff%d |cffff0000- Ticks : |cffffffff%d |cffff0000- Dmg : |cffffffff%d |cffff0000- Cibles : |cffffffff%d |cffff0000--|r",
			["combureport2"] = "|cffff0000 -- Prec. Combustion : |cffffffff%d |cffff0000- Ticks : |cffffffff%d |cffff0000- Dmg : |cffffffff%d |cffff0000- Cibles : |cffffffff%d |cffff0000--|r",
			}
			
-------------------------------
-- table for option mouseover info, no problem changing text lenght here too, tooltip size change according to lenght
combuoptioninfotableFR = {
	["CombuScaleSlider"] = "Utilisez cette réglette pour changer la taille de CombustionHelper. A noter que vous devrez ensuite le remettre en place.",
	["CombulockButton"] = "Verrouille la fenêtre principale quand la case est cochée.",
	["CombucritButton"] = "Acitve le moniteur de debuff de Masse Critique sur votre cible appliqué par les mages feu et les démonistes.",
	["ComburefreshButton"] = "Active le mode d'alerte dans votre fenêtre de discussion quand rafraichissez trop tôt ou que vous ratez votre Bombe Vivante (active aussi l'alerte sonore).",
	["CombureportButton"] = "Active le rapport de dégats dans la fenêtre principale de CombustionHelper pour tous les sorts monitorés. Il y a tout de même un délai car l'information n'est disponible qu'après le premier tick.",
	["Combureportthreshold"] = "Activez puis entrez une valeur dans la zone d'édition pour choisir un seuil de dégat d'Enflammer au dela duquel le fond de la fenêtre principale changera de couleur en fonction de la Combustion ou de l'Impact.",
	["Combureportvalue"] = "Activez puis entrez une valeur dans la zone d'édition pour choisir un seuil de dégat d'Enflammer au dela duquel le fond de la fenêtre principale changera de couleur en fonction de la Combustion ou de l'Impact.",
	["CombuIgnitePredictButton"] = "Active la prédiction de l'Enflammer pour le rapport de dégats. Cela permet d'avoir immédiatement la valeur théorique de votre Enflammer sans avoir à attendre que le premier tick intervienne. La valeur théorique aura un astérique devant elle pour que vous sachiez que cette valeur peut être erronée. Si la valeur prévue est correcte, le texte deviendra vert, dans le cas contraire il passera rouge.",
	["CombuIgniteAdjustbutton"] = "Le moteur de prédiction d'Enflammer enregistre les coups critiques susceptibles de générer un Enflammer et déduit la valeur de celui-ci selon un intervalle donné. La latence (lag) peut influer sur la précision de ce calcul. Pour le vérifier et le corriger éventuellement, testez sur un mannequin avec des brulures, si vous voyez beaucoup de textes rouges dans la fenêtre principale, augmentez cette valeur par incrément de 0,1 jusqu'à voir le plus de textes verts.", 
	["CombuIgniteAdjustvalue"] = "Le moteur de prédiction d'Enflammer enregistre les coups critiques susceptibles de générer un Enflammer et déduit la valeur de celui-ci selon un intervalle donné. La latence (lag) peut influer sur la précision de ce calcul. Pour le vérifier et le corriger éventuellement, testez sur un mannequin avec des brulures, si vous voyez beaucoup de textes rouges dans la fenêtre principale, augmentez cette valeur par incrément de 0,1 jusqu'à voir le plus de textes verts.",
	["CombuffbButton"] = "Active ou désactive le monitoring du dot de Givrefeu, quelque soit l'état du Glyphe de Givrefeu.",
	["CombuTimerbutton"] = "Entrez une valeur en secondes pour changer la zone d'alerte de toutes les barres de timers.",
	["CombuTimervalue"] = "Entrez une valeur en secondes pour changer la zone d'alerte de toutes les barres de timers.",
	["ComburefreshpyroButton"] = "Active les alertes dans votre fenêtre de discussion pour les oublis de Chaleur Continue et active le rapport d'utilisation en fin de combat.",
	["CombuimpactButton"] = "Active la gestion de l'Impact et le changement de couleur de fond de la fenêtre principale quand Combustion est en cooldown.",
	["CombutrackerButton"] = "Ajoute une barre de timer dans la zone de status pour montrer la durée de votre Combustion sur votre cible actuelle. Ajoute aussi les informations sur Combustion dans la fenetre de chat.",
	["CombuchatButton"] = "Active ou désactive l'affichage des messages de changement de configuration dans votre fenêtre de discussion.",
	["CombuLBtrackerButton"] = "Active ou désactive le moniteur de Bombe Vivante multiples. Cela ajoute un panneau à la fenêtre principale pour suivre les timers de vos bombes vivantes actives.",
	["CombuLBtargetButton"] = "En désactivant ce réglage, le moniteur de Bombe Vivante sera masqué quand vous n'avez qu'une seule Bombe Vivante active et qu'elle est sur votre cible.",
	["LBtrackerPosition"] = "Utilisez le menu déroulant pour choisir la position du moniteur de Bombes Vivantes autour de la fenêtre principale de CombustionHelper.",
	["LBtrackerDropDown"] = "Utilisez le menu déroulant pour choisir la position du moniteur de Bombes Vivantes autour de la fenêtre principale de CombustionHelper.",
	["CombuAutohideInfo"] = "Utilisez ce menu déroulant pour choisir le mode de masquage de CombustionHelper. Pas de masquage : garde la fenêtre visible en permanence. Masquage hors combat : affiche la fenêtre seulement pendant les combats. Masquage hors combat et Combustion dispo : affiche la fenêtre en combat et seulement quand Combustion est dispo.",
	["CombuAutohideDropDown"] = "Utilisez ce menu déroulant pour choisir le mode de masquage de CombustionHelper. Pas de masquage : garde la fenêtre visible en permanence. Masquage hors combat : affiche la fenêtre seulement pendant les combats. Masquage hors combat et Combustion dispo : affiche la fenêtre en combat et seulement quand Combustion est dispo.",
	["CombuBarButton"] = "Active ou désactive les barres de timers pour la Bombe Vivante, Enflammer, Explosion Pyrotechnique et Eclair de Givrefeu.",
	["CombuBarSlider"] = "Utilisez cette réglette pour ajuste la largeur des barres de timers des sorts gérés par CombustionHelper. Cela changera aussi la largeur de la fenêtre principale.",
	["Combubarcolornormal"] = "Cliquez sur cette touche pour ouvrir la roue des couleurs et choisir la nouvelle couleur de toutes les barres de timers de CombustionHelper quand le timer est supérieur à la valeur d'alerte.",
	["Combubarcolorwarning"] = "Cliquez sur cette touche pour ouvrir la roue des couleurs et choisir la nouvelle couleur de toutes les barres de timers de CombustionHelper quand le timer est inférieur à la valeur d'alerte.",
	["CombubeforefadeSlider"] = "Cette réglette changera le délai au dela duquel CombustionHelper commencera à se masquer après utilisation de Combustion. Par défaut, 15 secs.",
	["CombufadeoutspeedSlider"] = "Cette réglette changera le temps que mettra CombustionHelper à disparaitre au moment du masquage. Par défaut, 2 secs.",
	["CombufadedtimeText"] = "Cette valeur montre le temps que restera masqué CombustionHelper avant de revenir pour l'utilisation de la prochaine Combustion. Vous ne pouvez changer cette valeur car elle est liée aux autres réglages adjcacents.",
	["CombufadedtimeFrame"] = "Cette valeur montre le temps que restera masqué CombustionHelper avant de revenir pour l'utilisation de la prochaine Combustion. Vous ne pouvez changer cette valeur car elle est liée aux autres réglages adjcacents.",
	["CombufadeinspeedSlider"] = "Cette réglette changera le temps que mettra CombustionHelper à apparaitre en sortie de masquage. Par défaut, 2 secs.",
	["CombuafterfadeSlider"] = "Cette réglette changera le temps à partir duquel CombustionHelper va revenir avant que Combustion soit de nouveau disponible. Par défaut, 15 secs.",
	["ComburesetButton"] = "Utilisez ce bouton pour revenir aux réglages par défaut de CombustionHelper.",
	["CombuFlamestrikeButton"] = "Active ou désactive le moniteur de Choc de Flammes. Il vous montre le timer de votre dernier Choc de Flamme dans le moniteur de Bombe Vivante multiples. Il gère indépendamment le Choc de Flammes normal et celui généré par la vague d'Explosion car ces deux dots sont différents. Seul le dernier sort de chaque type est suivi pour éviter les timers inutiles.",
	["CombuMunchingButton"] = "Active ou désactive le rapport de bug d'Enflammer. Il enregistre tous les coups critiques qui provoquent un Enflammer ainsi que chaque dégat d'Enflammer et, à la fin du combat, CombustionHelper vous donnera tous ces résultats pour que vous sachiez combien de dégats vous avez perdu à cause du bug ou de la mort prématurée de votre cible. IMPORTANT : à cause de l'Impact et du transfert de dot, seuls les effets sur votre cible actuelle sont pris en compte. En outre cette fonction nécessite d'activer le système de prédiction d'Enflammer.",
	["Combubgcolorcombustion"] = "Pour choisir la couleur du fond et de la bordure quand Combustion est dispo et que les dots sont présents ou que le seuil d'Enflammer est activé et dépassé.",
	["Combubgcolorimpact"] = "Pour choisir la couleur du fond et de la bordure quand Impact est disponible.",
	["Combubgcolornormal"] = "Pour choisir la couleur du fond et de la bordure par défaut hors Combustion et impact. A noter que la couleur par défaut peut être trop foncée si vous changez le fond par défaut.",
	["CombuTextureDropDown"] = "Utilisez ce menu déroulant pour choisir la texture des barres de timers.",
	["CombuTextureInfo"] = "Utilisez ce menu déroulant pour choisir la texture des barres de timers.",
	["CombuFontDropDown"] = "Utilisez ce menu déroulant pour choisir la police de caractère pour tous les textes.",
	["CombuFontInfo"] = "Utilisez ce menu déroulant pour choisir la police de caractère pour tous les textes.",
	["CombuBorderDropDown"] = "Utilisez ce menu déroulant pour choisir la bordure de la fenêtre principale et du moniteur de Bombe Vivante.",
	["CombuBorderInfo"] = "Utilisez ce menu déroulant pour choisir la bordure de la fenêtre principale et du moniteur de Bombe Vivante.",
	["CombuBackgroundDropDown"] = "Utilisez ce menu déroulant pour choisir le fond de la fenêtre principale et du moniteur de Bombe Vivante.",
	["CombuBackgroundInfo"] = "Utilisez ce menu déroulant pour choisir le fond de la fenêtre principale et du moniteur de Bombe Vivante.",
	["CombuEdgeSizeSlider"] = "Utilisez cette réglette pour choisir l'épaisseur des bordures de la fenêtre principale et du moniteur de Bombe Vivante.",
	["CombuTileSizeSlider"] = "Utilisez cette réglette pour choisir la taille des tuiles de texture qui composeront le fond de la fenêtre principale et du moniteur de Bombe Vivante. Cette option n'est active que si le bouton de tuile de texture est coché.",
	["CombuTileButton"] = "Active ou désactive la répétition de tuiles de texture pour composer le fond de la fenêtre principale et du moniteur de Bombe Vivante. Les tuiles seront reproduites selon la taille choisie avec la réglette de taille de tuile.",
	["CombuInsetsSlider"] = "Utilisez cette réglette pour définir la distance du bord de la fenêtre à partir de laquelle le fond va commencer à apparaitre.",
	["CombuSoundInfo"] = "Utilisez ce menu déroulant pour choisir le son d'alerte lorsque le seuil d'Enflammer est atteint.",
	["CombuSoundDropDown"] = "Utilisez ce menu déroulant pour choisir le son d'alerte lorsque le seuil d'Enflammer est atteint.",
    ["CombuThresholdSoundButton"] = "Active l'alerte sonore lorsque le seuil d'Enflammer est atteint.",
	["Combuedgecolornormal"] = "Pour choisir la couleur de la bordure par défaut hors Combustion et impact.",
    ["CombuTickPredictButton"] = "Remplace l'affichage de la valeur d'Enflammer dans la zone de status par les dégats de vos ticks de Combustion ainsi que le nombre de ces ticks dépendant de votre hate.",
	}

-------------------------------
-- table for option panel localisation, try to stick to the lenght as it could overflow if bigger
CombuOptLocFR = {
	["CombuScaleSlider"] = "Taille",
	["CombulockButton"] = "Verrouille CombustionHelper",
	["CombucritButton"] = "Suivi de Masse Critique",
	["ComburefreshButton"] = "Alertes de Bombe Vivante",
	["CombureportButton"] = "Mode rapport de dégats",
	["Combureportthreshold"] = "Seuil :",
	["CombuIgnitePredictButton"] = "Prédiction d'Enflammer",
	["CombuIgniteAdjustbutton"] = "Timing d'Enflammer :", 
	["CombuffbButton"] = "Mode Eclair de Givrefeu",
	["CombuTimerbutton"] = "Alerte de timer :",
	["ComburefreshpyroButton"] = "Info Explosion Pyrotechnique",
	["CombuimpactButton"] = "Gestion de l'Impact",
	["CombutrackerButton"] = "Timer de dot Combustion",
	["CombuchatButton"] = "Messages de configuration",
	["CombuLBtrackerButton"] = "Moniteur de Bombe Vivante",
	["CombuLBtargetButton"] = "Montrer la cible dans le moniteur",
	["LBtrackerPosition"] = "Position du moniteur :",
	["CombuAutohideInfo"] = "Mode de masquage :",
	["CombuBarButton"] = "Barres de timers",
	["CombuBarSlider"] = "Largeur des barres",
	["CombuTextureInfo"] = "Texture des barres :",
	["CombuFontInfo"] = "Police de caractère :",
	["CombuBorderInfo"] = "Bordure des fenêtres :",
	["CombuBackgroundInfo"] = "Fond des fenêtres :",
	["CombuEdgeSizeSlider"] = "Taille des bordures",
	["CombuSliderInfo"] = "Ci dessous vous pouvez ajuster les délais de masquage en combat.",
	["CombubeforefadeSlider"] = "Pre fondu",
	["CombufadeoutspeedSlider"] = "Fondu",
	["CombufadedtimeText"] = "Masquage",
	["CombufadeinspeedSlider"] = "Retour",
	["CombuafterfadeSlider"] = "Post fondu",
	["ComburesetButton"] = "Réinitialisation",
	["CombuFlamestrikeButton"] = "Moniteur de Choc de Flammes",
	["CombuTileSizeSlider"] = "Taille des tuiles",
	["CombuTileButton"] = "Tuilage du fond",
	["CombuInsetsSlider"] = "Débord du fond",
	["Combubarcolornormal"] = "Couleur des barres (normal)",
	["Combubarcolorwarning"] = "Couleur des barres (alerte)",
	["Combubgcolornormal"] = "Couleur du fond (normal)",
	["Combubgcolorimpact"] = "Couleur du fond (Impact dispo)",
	["Combubgcolorcombustion"] = "Couleur du fond (Combustion dispo)",
	["CombuMunchingButton"] = "Info bug d'Enflammer",
    ["CombuLanguageInfo"] = "Langue :",
    ["CombuSoundInfo"] = "Alerte de seuil :",
    ["CombuThresholdSoundButton"] = "Alerte sonore de seuil",
	["Combuedgecolornormal"] = "Couleur de la bordure (normal)",
    ["CombuTickPredictButton"] = "Prediction des ticks de Combustion",
	}

-------------------------------
-- table for Living bomb tracker position dropdown
CombuLBpositionFR = {
   "En haut",
   "En bas",
   "A droite",
   "A gauche"
	}

-------------------------------
-- table for Autohide dropdown
CombuAutohideListFR = {
   "Pas de masquage",
   "Masquage hors combat seulement",
   "Masquage hors combat et Combustion en CD",
}

-------------------------------
-- table for text within frame, try to stick to the lenght as it could overflow if bigger
CombuLabelFR = {["autohide"] = "Masquage en cours.",
				["ignwhite0"] = "|cffffffff*%.0f Dgt|r",
				["dmggreen0"] = "|cff00ff00%.0f Dgt|r",
				["dmgred0"] = "|cffff0000%.0f Dgt|r",
				["dmgwhite0"] = "|cffffffff%.0f Dgt|r",
				["ignite"] = "|cffffffffEnflammer|r",
				["ignshort"] = "|cffff0000Enf|r",
				["flamestrike"] = "Choc de Flamme",
				["blastwave"] = "Vague Explo. CdF",
				["lbshort"] = "|cffff0000BV|r",
				["ffbglyph"] = "|cffff0000Glyphe|r",
				["ffbshort"] = "|cffff0000EdG|r",
				["frostfire"] = "Givrefeu",
				["pyroblast"] = "Exp. Pyro.",
				["lb"] = "Bombe Viv.",
				["pyroshort"] = "|cffff0000Pyro|r",
				["ignCBgreen"] = "|cff00ff00Enflam. %.0f - CB ok|r",
				["ignCBred"] = "|cffffcc00Enflam. %.0f - CB ok|r",
				["combup"] = "Combustion dispo !",
				["impactup"] = "|cff00ff00Impact - %.1f|r",
				["combmin"] = "Combustion ds %d:%0.2d",
				["combsec"] = "Combustion ds %.0fsec",
				["critmasswhite"] = "|cffffffff Masse Critique|r",
				["critmassred"] = "|cffff0000Masse Critique !!|r",
				}
				