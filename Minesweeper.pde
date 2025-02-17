import de.bezier.guido.*;
public final static int NUM_ROWS = 10; //all caps suggests constant
public final static int NUM_COLS = 10;
public final static int NUM_MINES = 15;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  Interactive.make( this );

  buttons = new MSButton[NUM_ROWS][NUM_COLS]; //first call to new
  for (int r=0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c); //second call to new
    }
  }
  setMines();
}
public void setMines()
{
  while (mines.size()<NUM_MINES) {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!(mines.contains(buttons[r][c]))) {
      mines.add(buttons[r][c]);
      //System.out.println((c+1) + ", " + (r+1));
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true) {
    displayWinningMessage();
    for (int i =0; i<= NUM_ROWS; i++) {
      for (int j = 0; j<=NUM_COLS; j++) {
        if (isValid(i, j)==true) {
          buttons[i][j].clicked=true;
        }
      }
    }
  }
}
public boolean isWon()
{
  int numSquares = 0;
  for (int i=0; i<NUM_ROWS; i++) {
    for (int j=0; j<NUM_COLS; j++) {
      if (buttons[i][j].clicked==true) {
        numSquares++;
      }
    }
  }
  if (numSquares == NUM_ROWS*NUM_COLS-NUM_MINES) {
    return true;
  }
  return false;
}
public void displayLosingMessage()
{
  for (int i =0; i<= NUM_ROWS; i++) {
    for (int j = 0; j<=NUM_COLS; j++) {
      if (isValid(i, j)==true) {
        buttons[i][j].clicked=true;
      }
    }
  }  
  for(int i=0; i<NUM_ROWS; i++){
    for(int j=0; j<NUM_COLS; j++){
      buttons[i][j].flagged=false;
    }
  }
  //System.out.println("YOU LOSE!");
  buttons[NUM_ROWS/2][NUM_COLS/2-4].setLabel("Y");
  buttons[NUM_ROWS/2][NUM_COLS/2-3].setLabel("O");
  buttons[NUM_ROWS/2][NUM_COLS/2-2].setLabel("U");
  buttons[NUM_ROWS/2][NUM_COLS/2-1].setLabel(" ");
  buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("L");//middle
  buttons[NUM_ROWS/2][NUM_COLS/2+1].setLabel("O");
  buttons[NUM_ROWS/2][NUM_COLS/2+2].setLabel("S");
  buttons[NUM_ROWS/2][NUM_COLS/2+3].setLabel("E");
  buttons[NUM_ROWS/2][NUM_COLS/2+4].setLabel("!");
}
public void displayWinningMessage()
{
  //System.out.println("YOU WIN!");
  for(int i=0; i<NUM_ROWS; i++){
    for(int j=0; j<NUM_COLS; j++){
      buttons[i][j].flagged=false;
    }
  }
  buttons[NUM_ROWS/2][NUM_COLS/2-4].setLabel("Y");
  buttons[NUM_ROWS/2][NUM_COLS/2-3].setLabel("O");
  buttons[NUM_ROWS/2][NUM_COLS/2-2].setLabel("U");
  buttons[NUM_ROWS/2][NUM_COLS/2-1].setLabel(" ");
  buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("W");//middle
  buttons[NUM_ROWS/2][NUM_COLS/2+1].setLabel("I");
  buttons[NUM_ROWS/2][NUM_COLS/2+2].setLabel("N");
  buttons[NUM_ROWS/2][NUM_COLS/2+3].setLabel("!");
}
public boolean isValid(int r, int c)
{
  if (r>=0 && c>=0 && r<NUM_ROWS && c<NUM_COLS) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i = row-1; i<= row+1; i++) {
    for (int j = col-1; j<=col+1; j++) {
      if (isValid(i, j)==true && mines.contains(buttons[i][j])) {
        numMines++;
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this );
  }

  public void mousePressed () 
  {
    if (mouseButton == RIGHT) {
      if (flagged == false) {
        flagged = true;
      } else {
        flagged = false;
        clicked = false;
      }
    } else {
      clicked = true;
      if (mines.contains(this)) {
        displayLosingMessage();
      } else if (countMines(myRow, myCol) > 0) {
        setLabel((countMines(myRow, myCol)));
      } else {
        for (int i = myRow-1; i<= myRow+1; i++) {
          for (int j = myCol-1; j<=myCol+1; j++) {
            if (isValid(i, j)==true && buttons[i][j].clicked==false) {
              buttons[i][j].mousePressed();
            }
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
