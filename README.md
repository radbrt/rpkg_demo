
# R-pakke med unit-tester og ci/cd walkthrough
En ikke-pakke for å vise hvordan lage R-pakker med tester og Travis.

<!-- badges: start -->
  [![Travis build status](https://travis-ci.org/radbrt/rpkg_demo.svg?branch=master)](https://travis-ci.org/radbrt/rpkg_demo)
  <!-- badges: end -->

## Hvordan lage en R-pakke, tester og CI/CD

Dette er en forklaring på hvordan å lage en ny pakke med R, Rstudio, Travis og mange nyttige bibliotek. Eksempelet har blitt laget på en Mac laptop, og for å følge denne manualen er du avhengig av å ha R, Rstudio og en rekke biblioteker inkludert `usethis`, `devtools`, `roxygen2` og `testthat`. I tillegg må maskinen ha Git installert, og du trenger konto på Github og Travis (travis-ci.com). At dette eksempelet bruker travis er utelukkende av pragmatiske årsaker, da Travis tilbyr gratis testing av åpen kildekode og R er støttet.

Vi forklarer ikke git inngående her, og selv om noen kommandoer forklares forventer vi i praksis at du har en grunnleggende kjennskap til git, eller at du stopper opp underveis og googler det som er nytt for deg.

1. Start med å åpne et nytt prosjekt, av typen "package":
 - Velg File > New Project
 - Fra menyboksen, velg New Directory > R Package
 - Skriv inn ønsket navn på pakken. Kan være lurt å holde seg til bokstaver, tall og understrek, uten spesialtegn.
 - Du skal nå ha fått opp et nytt R-prosjekt, med en fil som heter hello.R åpen i editoren.

2. Test-bygge pakken
 - hello.R filen inneholder litt tips, en eksempelfunksjon samt info om noen hurtigtaster.
 - Prøv CMD+SHIFT+E for å test-bygge pakken. Du får nå litt output i øvre høyre vindu som forteller om en Warning. Dette er fordi lisensen i DESCRIPTION-filen ikke er utfylt. Endre dette til CC0, og prøv på nytt.
 - Denne gangen skal du få 0 error, 0 warnings og 0 notes når du kjører CMD+SHIFT+E.

3. Git og Github
 - Initier repo lokalt, enten gjennom `git init` på kommandolinjen eller `usethis::use_git()` i konsollen.
 - Lag et nytt, tomt repo på github, og kopier `git remote add origin ...` kommandoen og kjør den i terminalen.

3. Ta i bruk nyttige hjelpemidler

	Vi kommer til å bruke noen veldig nyttige hjelpemidler (pakker som andre har utviklet) for å gjøre livet vårt enklere. Dette er pakker som bl.a. skriver nødvendige filer til prosjekt-mappen vår. Alt dette kan kjøres fra konsollen.
 - `usethis::use_roxygen_md()`, etterfulgt av `devtools::document()` - disse funksjonene skriver noen dokumentasjonsfiler (LaTeX) som inneholder blant annet manualen til funksjonene i pakken.
 - `usethis::use_testthat()` - dette lager en ny mappe, 'tests', som inneholder grunnlaget du trenger for å skrive tester.
 - `usethis::use_readme_md()`- lager en README.md fil, som vises direkte i git-repoet ditt op github - en slags intro for de som snubler over pakken.
 - `usethis::use_travis()` - lager en .travis.yml fil, som forteller Travis (travis-ci.com) hvordan å teste pakken. Dette er i utgangspunktet de samme testene som du kjører lokalt, men disse kjøres på nytt på en helt ren maskin hver gang du pusher til master. Når du kjører denne funksjonen ser du litt output i konsollen, som begynner med `<!-- badges: start -->`. Denne kan du kopiere inn i README filen din, og den blir til slutt den grønne (eller røde, hvis noe har gått galt) knappen som du ser nesten på toppen i denne READMEen. Den viser med andre ord statusen etter at Travis har kjørt.

5. Skrive tester (og funksjoner)!
	- Bør nesten ha noen funksjoner å teste først, så vi kan lage en sigmoid-funksjon. Åpne en ny R-fil, legg inn koden under, og lagre den i R-mappen hvor hello.R allerede ligger
	
```
	hypertan <- function(x) {
	  (exp(x)-exp(-x))/(exp(x)+exp(-x))
	}
```

 - Nå kan vi enkelt skrive en test for denne funksjonen. Åpne en ny R-fil, legg inn koden under, og lagre den i tests/testthat mappen. Viktig: Filen må begynne med 'test'. 
	
```
test_that("hypertan function intercept",
        		expect_equal(hypertan(0), 0)
  		 )
```

Disse funksjonsnavnene er nesten selvforklarende, men vi definerer altså en eller flere tester i `test_that` funksjonen. Første argument er en forklarende tekst for testen(e), deretter kommer en eller flere konkrete tester sammen med det forventede resultatet. Disse testene er typisk i form av at funksjonen din, med en gitt input-verdi, skal returnere en bestemt output. Her bruker vi en funksjon som sjekker om to verdier er like (`expect_equal`) for å sjekke om `hypertan(0)` er lik 0, noe vi vet at den skal være. Det finnes andre funksjoner, som f.eks. `expect_less_than` som er selvfoklarende, eller `expect_error` for tilfeller hvor du vil at funksjonen din skal returnere en error. Hvis du vil ha flere tester sammen i en `test_that` funksjon, skiller du disse med mellomrom.

 - Kjør testene ved å trykke CMD+SHIFT+T: du skal få én test med OK status.

6. Dokumentasjon

Vi har laget en ny funksjon, men ikke dokumentert den enda. I pakker må hver funksjon, og hvert datasett dersom du inkluderer eksempeldata, dokumenteres på en bestemt måte. Dette er den dokumentasjonen som brukerne ser, og den bør derfor være lett forståelig.

 - Sjekk pakken ved å kjøre CMD+SHIFT+E: Nå får du plutselig en ny feilmelding om at du har udokumentert kode. 
 - Dokumentasjon av funksjonen kan skrives over selve funksjonen, i en enkel men litt spesiell markdown-aktig kode, som inneholder Tittel, Beskrivelse, Parametre, og Eksempler. Lim inn over funksjonen:
    
```
#' Hyperbolic tangent function
#' Hypertan function for normalization.
#' @param x Input value
#' @examples
#' hypertan(1.5)
```
 - Lagre, og deretter kjør `devtools::document()`, som genererer den egentlige dokumentasjonen fra kommentarene over. Du skal nå ha fått melding om at det har blitt skrevet en ny fil.
 - Kjør CMD+SHIFT+E på nytt. Denne gangen skal du få 0 Errors, 0 Warnings og 0 Notes.

	Nå kan du laste pakken din (CMD+SHIFT+B), og kjøre `?hypertan` i konsollen for å få opp manualen til funksjonen din, og du ser resultatet av den markupen du skrev.

7. Push til github

	Nå er egentlig pakken ferdig, det gjenstår bare å laste den opp til github. Vi har gjort alt grunnarbeidet, og det eneste som gjenstår nå er de vanlige git-tingene, som kan gjøres enten fra terminalen eller grafisk fra Rstudio.
 - `git add .` Legger til alle filer slik at git holder øye med de.
 - `git commit -m "I can haz a package"` Committer koden (lager en milepæl), og legger ved en liten melding som forklarer hva du har gjort (siden forrige gang du committet).
 - `git push origin master` Sender koden videre til `origin` destinasjonen, som er den URL'en fra github-repoet vi lagde.

	Hvis du går inn på travis-ci.com nå, ser du at pakken din holder på å kjøre. Hvis alt går greit, skal du se et stort, grønt og hyggelig resultat, og i README'en din som vises på github kommer du til å se en tøff grønn knapp som sier "build passing".

8. Bruk master/dev branches, og begrens travis til master-branchen

Hvis du har et prosjekt som noen andre bruker samtidig som at du videreutvikler det, er det et poeng at du skal kunne bruke github når du utvikler samtidig som at andre skal kunne installere pakken din fra github. For å ordne dette kan du lage en ny branch, `dev`, eller lignende, hvor du utvikler, og som du kan merge med master branchen når det passer. Vi har dessverre ikke tid til å gå gjennom hva brancher er her.
 - Oppdater .travis.yml til å si at tester kun skal kjøres på master-branchen:
 
```
branches:
  only:
  - master
```
 - git add, commit og push endringen til master.

Deretter, lag en ny `dev` branch som vi kan jobbe på og merge til tider.

 - `git branch dev` Lager en ny branch med navnet `dev`
 - `git checkout dev` sier til git at det nå er `dev` branchen du jobber på
 - Legg inn en ny funksjon, dokumentasjon og test, f.eks. logistisk sigmoid. Lag en ny fil, `R/logisitic.R`:
 
```
  #' Logistic sigmoid function
  #' Logistic sigmoid function for normalization.
  #' @param x Input value
  #' @examples
  #' logistic_sigmoid(1.5)
  
  logistic_sigmoid <- function(x) {
    1/(1+exp(-x))
  }
```
  
Vi trenger også en test for koden, så lag en ny fil, `tests/testthat/test_sigmoid.R`:
  
```
test_that("Logistic function intercept",
        expect_equal(logistic_sigmoid(0), 0.5))
```

Når dette er på plass kan du kjøre tester lokalt (CMD+SHIFT+T) og test-bygge (CMD+SHIFT+E). Hvis dette går greit, lag en ny commit (husk at du er på dev-branchen nå), og push til github med `git push origin dev`.
	
Nå kan du merge dev og master via en "pull request" direkte på github. Da får du mulighet til å se gjennom forskjellene i koden, eventuelt skrive en kommentar eller rette noe, og kjøre travis-testene før koden merges.


