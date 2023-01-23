Author: Mario Saraiva

Date: Jun 2020 - Aug, 2022

# ProjetoRepartir

[PT] <em> Sobre o Projeto </em>:

O projeto REPARTIR oferece às famílias de baixa renda na área da grande Brasília (Brasil) (todo o Distrito Federal) apoio material, emocional e espiritual às famílias gravemente afetadas pelos múltiplos bloqueios pelos quais Brasília passou durante a pandemia do COVID-19. Criei um projeto de entrega de alimentos para ajudar famílias vulneráveis nos bairros mais pobres de Brasília que sofreram com o bloqueio do COVID-19 - desenvolvi um sistema personalizado sem custo para agilizar e automatizar o trabalho e aumentar significativamente a capacidade de processamento do projeto de 40 para cerca de 200 pedidos por mês. Gerenciou uma equipe de mais de 40 voluntários e estabeleceu procedimentos de entrega e saúde/segurança. Somente em 2020, foram entregues mais de 1.505 cestas básicas atingindo aproximadamente 5.267 indivíduos, dos quais 80% eram mães. As ferramentas usadas incluem produtos do google suite (unidade e planilhas), formulários ONA.io e scripts R/Python para automatizar a coleta de solicitações, limpeza e organização dos dados. Saiba mais em www.iirbrasil.com.br/ProjetoRepartir.

[EN] <em> About the Projeto Repartir </em>:

The REPARTIR project offers low-income families in the greater Brasilia (Brazil) area (whole Federal District) material, emotional and spiritual support to families severely affected by multiple lockdowns Brasilia went through during the COVID-19 pandemic. I created a food delivery project to help vulnerable families in the poorest neighborhoods of Brasilia that suffered from the COVID-19 lockdown—I developed a no-cost custom-based system to streamline and automate the work and significantly increase the project’s processing capacity from 40 to nearly 200 requests per month. Managed a team of 40+ volunteers and established delivery and health/security procedures. In 2020 alone, delivered over 1505 food baskets reaching approximately 5267 individuals, of which 80% were mothers. The tools used include google suite products (drive and sheets), ONA.io forms, and R/Python scripts to automate collecting requests, cleaning and wrangling the data. Find out more at www.iirbrasil.com.br/ProjetoRepartir.


## Behind the scenes Tech

The system behind the Repartir Project was composed of Google Sheets, R-scripts and an R-Shiny Dashboard. Another essential tool used extensively is Google Maps. Below I laid out the logical structure of the system and the accompanying R-scripts. In summary:

  1. Users request help via Google Forms;
  2. The team must sort through and validate requests;
  3. Validated requests are sent to the "to-be delivered" spreadsheet;
  4. We use a Whatsapp bot to confirm the address and, when needed, get the lat+long coordinates of the house. Unfortunately, many addresses are in unregulated zones without proper street signs and pavement.
  5. Personalized delivery HTML is generated for each route. (Usually, we have one route per vehicle)
  6. Teams record the delivery via an ONA (ODK form).
  7. Lastly, we update all spreadsheets with the successful deliveries and note the failed attempts.

## "Part A - Organizando os dados / Organizing the data"
          (*) "Passo 1 - Dar um ID para cada resposta recebida."
           (*) "Step 1 - Assign new IDs")

           (*) "Passo 2 - Copiar dados para aba '2.2.Triagem'."
            (*) "Step 2 - Copy data to sheet 2.2"
           
           (*) "Passo 3 - Copiar dados para aba '2.6 Orações'."
            (*) "Step 3 - Copy data to sheet 2.3"
           
           (*) "Passo 4 - Copiar IDs para aba '3.2 Preencher'."
            (*) "Step 4 - Copy IDs to sheet 3.2"
           
           (*) "Passo 5 - Atualizar planilha com novos contatos e download do arquivo csv."
            (*) "Step 5 - Update contact info and download contacts csv."


## Part B - Entrega das Cestas Básicas / Delivery of Food Baskets
           (*) "Passo 6 - Formatar os nomes dos beneficiarios que 
                       serão contactados via WhatsApp (Python Script)."
             (*) "Step 6 - Update list of contacts to receive WhatsApp message from Bot")
              
              [Manually generate google maps and calculate best routes given the ever changing team constraints]
              
           (*) "Passo 7 - Gerar HTML com as informações de entrega."
             (*) Step 7 - Generate HTML with delivery infomarion
              
## Part C - Pós-entregas / Post-delivery work
           
           (*) "Passo 8 - Atualizar sistema com as cestas já entregues.",
             (*) "Step 8 - Update after deliveries",
              
           (*) "Passo 9 - Atualizar planilha do mapa do site (Tableau).",
             (*) "Step 9 - Update Tableau data vizualisation.
             
             
