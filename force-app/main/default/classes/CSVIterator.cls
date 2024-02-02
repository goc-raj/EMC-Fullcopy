public class CSVIterator implements Iterator<CSVToContact>, Iterable<CSVToContact>{
   private List<CSVToContact> mlstCon;
   private Integer currentPosition;

   public CSVIterator(List<CSVToContact> lstCon ){  
      mlstCon = lstCon; 
      currentPosition = 0;
   }
   public Boolean hasNext(){
      return currentPosition < mlstCon.size()  ;
   } 
   public CSVToContact next(){
   if (currentPosition <mlstCon.size() ) {
      CSVToContact con = mlstCon[currentPosition];
      currentPosition++;
      return con;
      }
      return null;   
   }
   public Iterator<CSVToContact> Iterator(){
      return this;
   }
}