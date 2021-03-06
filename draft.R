ue <- read.csv('ue.csv', stringsAsFactors=F)

hosp <- read.delim('tps00046.tsv', stringsAsFactors=F, na.strings=c(':'), strip.white=T)
hosp$code <- gsub('.*,', '', hosp$unit.facility.geo.time)
hosp$unit.facility.geo.time <- NULL

names(hosp) <- gsub('X','', names(hosp))
cols_to_fix <- names(hosp)[-13]
tmp <- as.numeric(gsub(' .', '', as.matrix(hosp[,cols_to_fix])))
hosp[,cols_to_fix] <- tmp

hosp28 <- merge(hosp, ue, by="code")
hosp28$code <- NULL

psyc <- read.delim('tps00047.tsv', stringsAsFactors=F, na.strings=c(':'), strip.white=T)
psyc$code <- gsub('.*,', '', psyc$unit.facility.geo.time)
psyc$unit.facility.geo.time <- NULL

names(psyc) <- gsub('X','', names(psyc))
cols_to_fix <- names(psyc)[-13]
tmp <- as.numeric(gsub(' .', '', as.matrix(psyc[,cols_to_fix])))
psyc[,cols_to_fix] <- tmp

psyc28 <- merge(psyc, ue, by="code")
psyc28$code <- NULL

beds <- cbind(hosp28[,c('Country','2011')], psyc28[,'2011'])
names(beds) <- cbind('Country','Hospital','Psychiatric')
beds$Relation <- beds$Psychiatric / beds$Hospital
beds <- beds[complete.cases(beds),]

library(ggplot2)
ggplot(beds, aes(x=Country, y=Relation)) + geom_bar(stat="identity")

ggplot(beds, aes(x=Hospital, y=Psychiatric, label=Country)) + geom_text(vjust=1) + geom_point(aes(size=Relation*100))
ggplot(beds, aes(x=Hospital-Psychiatric, y=Psychiatric, label=Country)) + geom_text(vjust=1) + geom_point(aes(size=Relation*100))


