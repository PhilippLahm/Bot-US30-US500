//+------------------------------------------------------------------+ 
#property copyright "Copyright 2013, MetaQuotes Software Corp." 
#property link      "https://www.mql5.com" 
#property version   "1.00" 
//--- input parameters 
input string InpFileName="data.bin"; 
input string InpDirectoryName="Lam"; 
//--- global variables 
struct prices 
  { 
   datetime          date; // date 
   double            bid;  // bid price 
   double            ask;  // ask price 
  }; 
prices arr[]; 


int    count1=0; 
int    size1=20; 
string path=InpDirectoryName+"//"+InpFileName; 

void WriteData(const int n) 
  { 
   ResetLastError(); 
   int handle=FileOpen("test.txt",FILE_READ|FILE_WRITE|FILE_BIN); 
   if(handle!=INVALID_HANDLE) 
     { 
      //--- write array data to the end of the file 
      FileSeek(handle,0,SEEK_END); 
      FileWriteArray(handle,arr,0,n); 
      //--- close the file 
      FileClose(handle); 
     } 
   else 
      Print("Failed to open the file, error ",GetLastError()); 
  }
  
 void ReadData(){
   ResetLastError(); 
   int file_handle=FileOpen("test.txt",FILE_READ|FILE_BIN); 
   if(file_handle!=INVALID_HANDLE) 
     { 
      //--- read all data from the file to the array 
      FileReadArray(file_handle,arr); 
      //--- receive the array size 
      int size=ArraySize(arr); 
      //--- print data from the array 
      for(int i=0;i<size;i++) 
         Print("Date = ",arr[i].date," Bid = ",arr[i].bid," Ask = ",arr[i].ask); 
      Print("Total data = ",size); 
      //--- close the file 
      FileClose(file_handle); 
     } 
   else 
      Print("File open failed, error ",GetLastError()); 
 }
 
 void DeleteData(){
   FileDelete("test.txt");
 }