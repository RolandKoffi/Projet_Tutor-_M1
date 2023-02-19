# server.R

shinyServer(function(input, output, session) {
  
  # Nombre de sinistre par année
  output$nbSinYear <- renderPlot({
     val <- dataset %>% group_by(ANNEE) %>% summarise(Nombre = sum(NBSIN))  
     # print(val)
     # print(mean(val$Nombre))
     ggplot(val, aes(x = ANNEE, y = Nombre)) + geom_smooth() + theme(panel.background = element_rect(fill = "white", colour = "grey50")) 
  })
  
  # Benefice par année
  output$benefParAnnee <- renderPlot({
    val2 <- dataset %>% group_by(ANNEE) %>% summarise(Benefice = sum(round(as.numeric(GAIN_PAR_CONTRAT),2)))
    #print(val2)
    ggplot(val2, aes(x = ANNEE, y = Benefice)) + geom_smooth() + theme(panel.background = element_rect(fill = "white", colour = "grey50")) 
  })
  
  # Nombre de sinistre par zone
  output$nbSinZon <- renderPlot({
    val3 <- dataset %>% group_by(CODEZONE) %>% summarise(Nombre = sum(NBSIN))
    ggplot(val3, aes(x = "", y = Nombre, fill = CODEZONE)) + geom_bar(stat="identity", width=1, color="white") + coord_polar("y", start=0) + theme_void() 
  })
  
  # Nombre d'individu par code genau
  output$nbIndivCodGen <- renderPlot({
    ggplot(dataset, aes(x = CODGENAU, fill = CODGENAU)) + geom_histogram(stat = "count") + theme(panel.background = element_rect(fill = "white", colour = "grey50"))
  })
  
  # Nombre d'individus ayant résilié leurs contrats par zone géographique
  CODE_ZONE <- as.factor(dataset_neg$CODEZONE)
  output$nbIndivResiContr <- renderPlot({
    ggplot(dataset_neg, aes(x = ANNEE, fill = CODE_ZONE)) + geom_histogram(stat = "count") + theme(panel.background = element_rect(fill = "white", colour = "grey50"))
  })
  
  # Nombre de contrat par année
  output$nbContrAnn <- renderPlot({
    val4 <- dataset %>% group_by(ANNEE) %>% summarise(Nombre = n())
    ggplot(val4, aes(x = ANNEE, y = Nombre)) + geom_smooth() + theme(panel.background = element_rect(fill = "white", colour = "grey50"))
  })
  
  
  # Texte pour la probabilité de sinistre
  output$titreRentEco <- renderText({
    paste("La rentabilité en fonction de ces données est : ")
  })
  
  # Prediction de la rentabilité économique
  output$rentEco <- renderText({
    valeurGain <- 1.675*(10^4) + (1.579*10^(-1))*as.numeric(input$prim) - (1.139*10^(-1))*as.numeric(input$chargNet) - (1.937*10^(-1))*as.numeric(input$coutMoySin) 
    paste(round(valeurGain,3),"FCFA")
  })
  
  # Texte pour la probabilité de sinistre
  output$text <- renderText({
    paste("La probabilité de faire un sinistre est : ")
  })
  
  # Calcul de la probalibilté de sinistre
  output$probaSin <- renderText({
    logit_ypredit = -4.601341 - 0.337021 * as.numeric(input$zoneGeo) - 0.643624 * as.numeric(input$typeMote) + 0.071374 * as.numeric(input$codeGen)
    y_predit = exp(logit_ypredit)/(1+ exp(logit_ypredit))
    paste(round(100*y_predit,2),"%")
  })
  
  
  #- create footer as running message commnunication
  output$dynamicFooter <- renderFooter({ dashboardFooter(subText = HTML("<b>Made by Gérald & Roland </b>")) })
  
})
