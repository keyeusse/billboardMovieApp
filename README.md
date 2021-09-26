# billboardMovieApp
This project is a challenge by Rappi


## Video
You can find the app video in this link
    -- https://youtu.be/sqgdw0oIGAw

## Run project

Go to `/BillboardMovieApp`. Open a terminal in that route:

//Copy this line in terminal
> pod install

Continue executing line: 
> open BillboardMovieApp.xcworkspace

Finally,  **Build and Run** project BillboardMovieApp


# About project

 For developing this project it was neccessary to use some framework:

* Alamofire
* ObjectMapper
* Youtube Player


# App can do

    * Watch movie list
    * Watch movie genre list
    * You can watcht choose a movie and find some information about it
    * You can filter movie category to find one faster
    * You can use it without a internet connection



# Architecture

App has a VIPPER ARCHITECTURE, for that reason, this is the structrute inside it:

- CoreDataManager: Catch data from API to save locally.

- APIServiceManager: HTTP calls to API to get movie information.

- Resources: There are some classes can help us to manage general styles.

- AppModules: Division for app features.
    * Billboard: Load all movie's information
    * CategoryMovieFilter> Filter movies by genre
    * DetailMovie: User can read some information about a specific movie


# Unit Test

- BillboardMovieAppTests:  Project contains unit test for calling to API. MovieList and GenreList


# Preguntas
   
## 1.- ¿En qué consiste el principio de responsabilidad única? ¿Cuál es su propósito?
   
   Este principio establece que cada clase, función, estructura o bloque de código tiene una tarea. El propósito es tener una arquitectura limpia, que al modificar un bloque de código el impacto sea grande y limpio. Esto además permite reutilizar y crear capas para el mejor mantenimiento.
      
## 2.- ¿Qué características tiene, según su opinión, un “buen” código o código limpio?

   Un buen código comienza desde que es legible, variables simples, comentado, enfocado a las estructuras de datos mas que a las librerias o el lenguaje. Envitar errores de ausencia de datos `nil values`. 
    Detectar si el código se repite mucho, entonces es factible una refactorización y quizas el uso de patrones de diseño pueda ser una solución *(sin caer en los antipatrones)*. La declaración explicita de datos, con el fin de ser claros en nuestros valores y evitar inferencia de tipos, entre otras técnicas. Respetar la arquitectura establecida. Y el uso de Unit Tests para asegurar el funcionamiento correcto del proyecto. 


