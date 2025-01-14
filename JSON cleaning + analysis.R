
#Working-Directory ändern
setwd("~/path/to/your/project/directory")

#JSON-Datei einlesen

install.packages("jsonlite")
library(jsonlite)

json_data <- stream_in(file("521161504.json"))

#Daten in tabellarische Form bringen 

data <- json_data[[3]][[1]]

#Reviews als CSV-Datei speichern
write.csv(data[,1][6],"Reviews.csv", row.names = FALSE)

#Produktreviews speichern
reviews <- data[,1][6]

#Städtenamen speichern
city_names <- data[,1][25]

#Beispiel-Review ausgeben

print(reviews[100,1])

###Produktreviews cleanen###

install.packages("tm")
library(tm)

#alles klein schreiben
reviews <- tolower(reviews$text)

#Beispiel-Review ausgeben
print(reviews[1])

#Satzzeichen entfernen
reviews <- removePunctuation(reviews)
print(reviews[1])

#Zahlen entfernen
reviews <- removeNumbers(reviews)
print(reviews[1])

#Stopwords entfernen (häufig benutzte Wörter, die aber keinen Sinninhalt haben, z.B. also, aber, dabei)
reviews <- removeWords(reviews, stopwords("german"))
print(reviews[1])

#überschüssige Leerzeichen entfernen
reviews <- stripWhitespace(reviews)
print(reviews[1])

#überschüssige Leerzeichen zu Beginn/Ende entfernen
reviews <- trimws(reviews)
print(reviews[1])

#Wortendungen entfernen (Stemming), z.B. schuhe --> schuh
#reviews <- stemDocument(reviews, language = "german")
#print(reviews[1])

print(head(reviews))

###Produktreviews analysieren###

#Reviews hintereinander ketten
asone <- paste(reviews, collapse = ' ')

#zu Corpus zusammenfassen
corp <- Corpus(VectorSource(asone))

#Term-Document-Matrix erstellen
TDM <- TermDocumentMatrix(corp)

#TDM inspizieren
inspect(TDM)
View(as.matrix(TDM))

#zehn häufigste Wörter finden
findMostFreqTerms(TDM, 10)

#2-grams bestimmen
install.packages ("ngram")
library(ngram)

ng <- ngram(asone, n=2)

#häufigste 2-grams
pt.2 <- get.phrasetable(ng)

#3-grams bestimmen
ng <- ngram(asone, n=3)

#häufigste 3-grams
pt.3 <- get.phrasetable(ng)

#Wordclouds erstellen

install.packages("wordcloud")
library(wordcloud)

#TDM in Matrix umwandeln
TDM.matrix = as.matrix(TDM)

#Zeilennamen in Spalte umwandeln
TDM.matrix <- data.frame(names = row.names(TDM.matrix), TDM.matrix)

#Wordcloud für häufigste Wörter erstellen
wordcloud(words = TDM.matrix[,1], freq = TDM.matrix[,2], min.freq = 1,max.words=100, random.order=FALSE, rot.per=0.35,colors=brewer.pal(8, "Dark2"))

#Sentiment-Analyse

library(tidytext)
get_sentiments(lexicon = "nrc")
?get_sentiments

library(Syuzhet)

get_nrc_sentiment(asone, language = "german")
?get_nrc_sentiment
