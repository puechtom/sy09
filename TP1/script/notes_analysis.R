#Chargement des donn�es
notes <- read.csv("sy02-p2016.csv", na.strings="", header=T)
notes$nom <- factor(notes$nom, levels=notes$nom)
notes$correcteur.median <- factor(notes$correcteur.median,
                                  levels=c("Cor1","Cor2","Cor3","Cor4","Cor5","Cor6","Cor7","Cor8"))
notes$correcteur.final <- factor(notes$correcteur.final,
                                 levels=c("Cor1","Cor2","Cor3","Cor4","Cor5","Cor6","Cor7","Cor8"))
notes$niveau <- factor(notes$niveau, ordered=T)
notes$resultat <- factor(notes$resultat, levels=c("F","Fx","E","D","C","B","A"),
                         ordered=T)

#Summary
summary(notes)

library(epitools)
library(ggplot2)
library(tidyr)

#Etudes des liens statistiques entre variables

# Influence de la formation d'origine
#   Soit l'hypothese nulle suivante : les variables r�sultat et dernier.diplome.obtenu
#   sont ind�pendantes. Nous allons donc r�aliser un test d'ind�pendance entre ces 2
#   variables qualitatives. Pour cela, nous allons utiliser un test du chi2.
#   G�n�ration du tableau de contingence :
tableau = table(notes$dernier.diplome.obtenu, notes$resultat)
tableau
#   V�rification des effectifs th�oriques :
effth = expected(tableau)
effth
#   Afin de respecter les conditions de Cochran, nous allons garder uniquement les classes
#   qui ont au moins 80% de leurs effectifs th�oriques sup�rieurs � 5. On obtient alors
#   le tableau de contigence suivant :
tableau = tableau[c("BAC", "CPGE", "DUT"),]
#   Test du chi2 :
test = chisq.test(tableau)
test
#   Nous avons ici I=3 et J=7, donc la loi du chi2 utilis�e aura (3-1)*(7-1)=12 degr�s de
#   libert�s.
#   La probabilit� d'avoir un indicateur de chi2 de 34,15 pour 12 degr�s de libert�s est
#   de moins de 1 pour 1000 (0,001) comme nous l'indique la p-value de 0,0006389.
#   De maniere g�n�rale, on accepte l'hypothese nulle (ind�pendance) lorsque la p-value
#   est sup�rieure � 5% (0,05). La p-value �tant ici inf�rieur � 1 pour 1000, on peut donc alors
#   rejeter l'hypothese nulle d'ind�pendance. On affirme donc avec moins d'une chance sur mille de
#   se tromper que les variables resultat et dernier.diplome.obtenu sont d�pendantes.
#   Interpretons alors ces resultats:
#   La commande test$observed permet d'afficher notre tableau d'origine.
test$observed
#   La commande test$expected permet d'afficher le tableau des effectifs th�oriques.
test$expected
#   Enfin, la commande test$residuals permet d'afficher le tableau des r�sidus.
test$residuals
#   Nous allons utiliser ce tableau des r�sidus afin de calculer le tableau des �carts
#   � l'ind�pendance :
res = test$residuals*test$residuals
res
res.df = as.data.frame.matrix(res)
res.df$diplome = rownames(res.df)
res.df.g = gather(res.df, type, value, -diplome)
ggplot(res.df.g, aes(type, value)) + 
       geom_bar(aes(fill = diplome), stat = "identity", position = "dodge")
#   De maniere g�n�rale, les notes obtenues par les eleves provenant de CPGE ne permettent pas
#   d'expliquer cette d�pendance. N�anmoins, les notes obtenues par les eleves post BAC
#   permettent d'expliquer en grande partie cette d�pendance.



# Influence de leur branche
#   Soit l'hypothese nulle suivante : les variables resultat et specialite
#   sont ind�pendantes. Nous allons donc r�aliser un test d'ind�pendance entre ces 2
#   variables qualitatives. Pour cela, nous allons utiliser un test du chi2.
#   G�n�ration du tableau de contingence :
tableau = table(notes$specialite, notes$resultat)
tableau
#   V�rification des effectifs th�oriques :
effth = expected(tableau)
effth
#   Afin de respecter les conditions de Cochran, nous allons garder uniquement les classes
#   qui ont au moins 80% de leurs effectifs th�oriques sup�rieurs � 5. On obtient alors
#   le tableau de contigence suivant :
tableau = tableau[-c(7:9),]
tableau = tableau[-4,]
#   Test du chi2 :
test = chisq.test(tableau)
test
test$expected
#   Nous avons ici I=5 et J=7, donc la loi du chi2 utilis�e aura (5-1)*(7-1)=24 degr�s de
#   libert�s.
#   La probabilit� d'avoir un indicateur de chi2 de 23,588 pour 24 degr�s de libert�s est
#   de 48%, p-value 0,4853.
#   On accepte donc l'hypothese nulle puisque la p-value est bien sup�rieur � 5%. Il semblerait
#   donc qu'il n'y est pas de d�pendance statistique entre la specialite et le resultat.



# Influence de leur niveau
#   Soit l'hypothese nulle suivante : les variables resultat et niveau
#   sont ind�pendantes. Nous allons donc r�aliser un test d'ind�pendance entre ces 2
#   variables qualitatives. Pour cela, nous allons utiliser un test du chi2.
#   G�n�ration du tableau de contingence :
tableau = table(notes$niveau, notes$resultat)
tableau
#   V�rification des effectifs th�oriques :
effth = expected(tableau)
effth
#   Afin de respecter les conditions de Cochran, nous allons garder uniquement les classes
#   qui ont au moins 80% de leurs effectifs th�oriques sup�rieurs � 5. On obtient alors
#   le tableau de contigence suivant :
tableau = tableau[c(1,2,4),]
tableau
#   Test du chi2 :
test = chisq.test(tableau)
test
#   Nous avons ici I=3 et J=7, donc la loi du chi2 utilis�e aura (3-1)*(7-1)=12 degr�s de
#   libert�s.
#   La probabilit� d'avoir un indicateur de chi2 de 30,22 pour 12 degr�s de libert�s est
#   de moins de 1 pour 100 (0,01) comme nous l'indique la p-value de 0,002587.
#   On affirme donc avec moins de 0,3% de chance de se tromper que les variables resultat
#   et niveau sont d�pendantes.
#   Interpretons alors ces resultats:
#   Nous allons utiliser le tableau des r�sidus afin de calculer le tableau des �carts
#   � l'ind�pendance :
res = test$residuals*test$residuals
res
res.df = as.data.frame.matrix(res)
res.df$niveau = rownames(res.df)
res.df.g = gather(res.df, type, value, -niveau)
ggplot(res.df.g, aes(type, value)) + 
  geom_bar(aes(fill = niveau), stat = "identity", position = "dodge")



#Influence du correcteur sur la note
#   Soit l'hypothese nulle suivante : les variables resultat et correcteur
#   sont ind�pendantes. Nous allons donc r�aliser un test d'ind�pendance entre ces 2
#   variables qualitatives. Pour cela, nous allons utiliser un test du chi2.
#   G�n�ration du tableau de contingence :
tableau1 = table(notes$correcteur.final, notes$resultat)
tableau1
tableau2 = table(notes$correcteur.median, notes$resultat)
tableau2
tableau = tableau1 + tableau2
tableau
#   On retire le correcteur 2 et 8 car donn�es manquantes :
tableau = tableau[-c(2,8),]
#   V�rification des effectifs th�oriques :
effth = expected(tableau)
effth
#   Les conditions de Cochran sont ici respect�es, il n'est donc pas n�cessaire de retirer
#   des classes.
#   Test du chi2 :
test = chisq.test(tableau)
test
#   Nous avons ici I=6 et J=7, donc la loi du chi2 utilis�e aura (6-1)*(7-1)=30 degr�s de
#   libert�s.
#   La probabilit� d'avoir un indicateur de chi2 de 25,337 pour 30 degr�s de libert�s est
#   de 70%, p-value 0,7085.
#   On accepte donc l'hypothese nulle puisque la p-value est bien sup�rieur � 5%. Il semblerait
#   donc qu'il n'y est pas de d�pendance statistique entre le correcteur et le resultat.