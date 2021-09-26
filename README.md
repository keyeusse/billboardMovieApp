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

- BillboardMovieAppTests:  Project contains unit test for calling to API. 
* MovieList 
* GenreList

##### Sesision of answer to challenge question
# Questions
   
## 1.- ¿Single Responsibility Principle?
   
   Single Responsibility Principle (SRP) consist of every single part (module, clase, interface...) has an only responsability and functioning in code. This principle let us to have a code cleanning project,  strongly and completly disconnected, and developer can change any module with load impact.
      
## 2.- ¿Cleanning code (my opinion)?


   * A nice and usefull code is strongly and totally disconnected and independent for other modules. Because, developer can change something and this is not so impacting.
   * Use classes, imports, frameworks, api's... really neccesary.
   * Implement cleaning architectures and participles. 
   * Use a repository for segurity


