# ui.R

ui <- dashboardPage(
  
  skin = "purple", title = "IDSI",
  
  #- header
  dashboardHeader(
    
    title = HTML(paste0(
      '<span class = ""fa-thin fa-bars"><b>DS</b> Projet Sanlam</span>',
      '<span class = "logo-mini"><b>DS</b></span>'
    )),
    
    titleWidth = 300
  ),
  
  #- sidebar
  dashboardSidebar(
    
    width = 300,
    
    sidebarMenu(
      
      id = "sidebar_main",
      
      menuSegment("MENU"),
          
      menuItem("Dashboard", tabName = "dh", icon = icon("dashboard")), 
      
      menuItem("Statistiques", tabName = "stats", icon = icon("th")),
      
      menuItem("Prévisions", tabName = "prvs", icon = icon("bar-chart-o"))

    )
    
  ),
  
  #- body
  dashboardBody(
    
    # custom css and js
    tags$head(tags$script(src="js/enter_as_click.js")),
    
    # CSS
    tags$style(
      "#probaSin {
          color : red;
          font-size : 200px;
          font-weight : bold;
        }

      #rentEco {
              color : green;
              font-size : 120px;
              font-weight : bold;
          }
      #text, #titreRentEco {
          font-size : 20px;
          text-align : left;
          font-weight : bold;
          
      }"
    ),
    
    # add tab w.r.t menu
    tabItems(
      
      tabItem(
        
        tabName = "dh",
        
        h2("Dashboard"),
        
        
        fluidRow(

          # A static valueBox
          valueBox(value = paste(2,606,555,207,"FCFA"), subtitle = "Bénéfice de la dernière année de la RC", icon = icon("money"), color = "aqua", width = 4),
          
          valueBox(value = 1110, subtitle = "Nombre moyen de sinistre par année", icon = icon("link"), color = "green", width = 4),
          
          valueBox(value = paste(540,619), subtitle = "Nombre de clients actifs", icon = icon("user"), color = "purple", width = 4)
          
        ),
        
        fluidRow(
          column(
            width = 4,
            box(title = "Nombre de sinistre par année", status = "primary", plotOutput("nbSinYear", height = 480), height = 550, width = 200),
          ),
          
          column(
            width = 8,
            box(
              title = "Evolution du bénéfice par année", status = "warning",
              width = 200,
              height = 550,
              plotOutput("benefParAnnee", height = 480)
            )
          )
        )

      ),

      tabItem(
        
        tabName = "stats",
        
        h2("Statistiques sur les données"),
        
        fluidRow(
          
          box(
            title = "Nombre de sinistre par zone", status = "primary", 
            background = NULL, width = 6, height = 333,
            plotOutput("nbSinZon", height = 280)
          ),
          
          box(
            title = "Nombre d'individus par Code Genau", footer = NULL, status = "warning", 
            background = NULL, width = 6, height = 333,
            plotOutput("nbIndivCodGen", height = 280)
          )
          
        ),
  
        fluidRow(
          
          box(
            title = "Nombre d'individus ayant résilié leurs contrats par zone géographique", status = "danger", 
            background = NULL, width = 6, height = 333,
            plotOutput("nbIndivResiContr", height = 280)
          ),
          
          box(
            title = "Nombre de contrat par année", footer = NULL, status = "primary", 
            background = NULL, width = 6, height = 333,
            plotOutput("nbContrAnn", height = 280)
          )
          
        )
         
      ),
      
      tabItem(
        
        tabName = "prvs",
        
        h2("Prévisions"),
        
        fluidRow(
          tabBox(
            # Title can include an icon
            tabPanel(
              "Rentabilité économique",
              fluidRow(
                column(
                  width = 4,
                  sliderInput(
                    "prim", 
                    "Prime nette",
                    min = 100, max = 500000, value = 500, step = 1000
                  ),
                  numericInput(
                    "chargNet",
                    "Charge nette",
                    0,
                    85601058,
                    50000,
                    5000
                  ),
                  numericInput(
                    "coutMoySin",
                    "Cout moyen de sinistre",
                    0,
                    74263769,
                    50000,
                    5000
                  ),
                  submitButton("Valider")
                ),
                
                column(
                  width = 8,
                  p(textOutput("titreRentEco")),
                  p(textOutput("rentEco"))
                )
              )
            ),
            tabPanel(
              "Possibilité de sinistre", 
              fluidRow(
                column(
                  width = 4,
                  selectInput(
                    "typeMote",
                    "Type de moteur",
                    c("Diesel" = 1,"Essence" = 2),
                    FALSE
                  ),
                  radioButtons(
                    "zoneGeo",
                    "Zone géographique",
                    c(1,2,3),
                    inline = F
                  ),
                  selectInput(
                    "codeGen",
                    "Genre du vehicule",
                    c("Voiture particulière" = 18, "Remorque" = 10, "Taxi Ville" = 22, 
                      "Taxi Brousse"= 12, "Vehicule 2 Roues" = 1, "Vehicule 3 Roues" = 2, 
                      "Vehicule 4 Roues (masse <= 150KG)" = 3, "Tandem" = 13,
                      "V. T.  Avec Double Commande" = 16, "V. T.  Sans Double Commande" = 17, "V. U. Avec Double Commande" = 23, "V. T. C. Avec Double Commande" = 26,
                      "V. T. C. Sans Double Commande" = 27, "V. U. Sans Double Commande" = 24, "Vehicule 4 Roues" = 9, "Cyclomoteur" = 25, "Autres vehicules 2/3 Roues" = 5,
                      "Vehicule Type Speciaux" = 19, "Semi-Remorque" = 11, "NON APPLICABLE" = 14, "Tracteur Routier" = 15, "Vehicule utilitaire" = 20, "Autocars" = 4, 
                      "Engin de Chantier" = 6, "Vehicule  2/3/4 Roues (masse > 150Kg)" = 8, "Engins de Chantier" = 21),
                    FALSE
                  ),
                  submitButton("Valider")
                ),
                
                column(
                  width = 8,
                  p(textOutput("text")),
                  p(textOutput("probaSin"))
                )
              )
              ),
            height = 680,
            width = 12
          )
        )
        
      )
      
    )
    
  ),
  
  # #- footer
  footerOutput(outputId = "dynamicFooter"),
  # 
  # #- controlbar
  dashboardControlbar()
  
)
