#----------------------------------------------------
# Usage:
# 1st) create a matrix:   
#      c = rbind(c(1, -1/4), c(-1/4, 1))
#      class(c) 
#      mcm <- makeCacheMatrix(c)
#      mcm$get()
#      cacheSolve(mcm)
#
#----------------------------------------------------
usage<- function(){  
  print("1) create a matrix.  example:  x = rbind(c(4, 3), c(3, 2))")
  print("2) store the matrix into the cache function. example:  mcm <- makeCacheMatrix(x) ")
  print("3) use the 'get()' function to display the matrix. example:  mcm$get()  ")
  print("4) call cacheSolve function to get the inverse matrix. example: cacheSolve(mcm)")
  print("5) all subsequent calls to the 'cacheSolve' would return the cached value.")
}


#----------------------------------------------------
## makeCacheMatrix defines a set of functions to 
## set a matrix
## get the matrix
## set the inverse matrix 
## get the inverse matrix
#----------------------------------------------------
makeCacheMatrix <- function(x = matrix()) {

  # variable to store the cached inverse matrix
  invMatrix<-NULL
  
  # setter for the matrix.  makeCacheMatrix(x)
  set<-function(value){
    x<<-value
    invMatrix<<-NULL
  }
  
  # getter the matrix
  get<-function(){
    x
  } 
  
  # saves the inverse of the matirx
  setmatrix<-function(inv){
    invMatrix<<- inv 
  }
  
  # gets the inverse of the matrix
  getmatrix<-function(){
    invMatrix
  }
  
  list(set=set, get=get, setmatrix=setmatrix, getmatrix=getmatrix)
}



#----------------------------------------------------
# this function first looks into the cache for the
# previously cached value, if nothing was found then
# it will calculate the matix inverse and caches the value.
#
#  The inverse of a square matrix A is a matrix A^(-1) 
# such that  AA^(-1)=I, 
#----------------------------------------------------
cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'

  m<-x$getmatrix()
  if(!is.null(m)){
    message("getting cached data")
    return(m)
  }
  
  m<-x$get()
  
  m<-solve(m, ...)
  
  #cache the matrix
  x$setmatrix(m)
  
  return (m)
}
