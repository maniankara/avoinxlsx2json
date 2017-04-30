extern crate calamine;

use calamine::{Sheets, Range, DataType};

fn main() {
    let mut excel = Sheets::open("testdata/pollution.xlsx").unwrap();
    let workSheet = excel.worksheet_range("NO").unwrap();
    for row in workSheet.rows {

        println!("row[0]={:?}, row={:?}", row[0], row[1]);
    }
}
