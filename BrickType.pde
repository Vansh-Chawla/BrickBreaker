/*
    Enum was written using outline of how enums work with methods and a constructor from an article by GeeksForGeeks "enum in Java"
    at https://www.geeksforgeeks.org/enum-in-java/ (last accessed 2025-03-16)
*/

enum BrickType {

    // I tried using the Processing color() method here, but fell into the issue described due to the enum being static: 
    // https://forum.processing.org/two/discussion/21780/static-methods.html
    // used https://forum.processing.org/one/topic/fill-with-variable-hex-code-doesn-t-work.html
     
    RED(3, new color[]{ #C83232, #FF6464, #FF9696}), 
    YELLOW(1, new color[]{ #F0C850}),
    GREEN(2, new color[]{ #50A050, #78C878});
    // for hex colors used https://www.rgbtohex.net/

    int hitsToDestroy;

    // This stores the next color(s) of the brick to be displayed after it is hit.
    // The first color is the starting color, and as you hit bricks (that take multiple hits) the color gets lighter
    color[] progressColors; 


    BrickType(int hitsToDestroy, color[] progressColors) {
        this.hitsToDestroy = hitsToDestroy;
        this.progressColors = progressColors;
    }

    color getColor(int hitCount) {
        return progressColors[hitCount]; 
    }

    
}