extern crate calamine;
extern crate chrono;

#[macro_use]
extern crate serde_json;

use calamine::{Sheets, Range, DataType};
use chrono::prelude::*;

use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

use serde_json::{Map, Value};

fn convert_to_map(l: String, lat: f64, long: f64) -> String {
    let mut gps_map = Map::new();
    gps_map.insert("location".to_string(), l);
    gps_map.insert("lat".to_string(), lat);
    gps_map.insert("long".to_string(), long);
    serde_json::to_string(& gps_map).unwrap();
}

fn main() {

    convert_to_map("Mannerheimintie", 60.167999328, 24.937329584);
    convert_to_map("Kallio", 60.183832598, 24.942829562});
    gps_map.insert("Tikkurila", Gps {latitude: 60.2999988, longitude: 25.0499998});
    gps_map.insert("Leppavaara", Gps {latitude: 60.2166658, longitude: 24.8166634});
    gps_map.insert("Tapiola", Gps {latitude: 60.171999312, longitude: 24.801496794});

    let mut excel = Sheets::open("testdata/pollution.xlsx").unwrap();
    let workSheet = excel.worksheet_range("NO").unwrap();
    for row in workSheet.rows() {
        // skip all the empties
        if row[0] == DataType::Empty {
            continue;
        }
        // convert to date
        if let DataType::Float(year) = row[0] {
            if let DataType::Float(month) = row[1] {
                let dt = UTC.ymd(year as i32, month as u32, 1);
                // println!("{:?}", dt);
            }
        }

    }

    let j = json!({
        "name" : "a1",
        "list" : [
            "10",
            1
        ]
    });

    //path
    let path = Path::new("NO.json");

    // open
    let mut file = match File::create(&path) {

        Err(e) => panic!("Failed to create: {:?}", path),

        Ok(file) => file
    };


    match file.write_all(j.to_string().as_bytes()) {

        Err(e) => panic!("Couldnt write to {:?}", path),

        Ok(_) => println!("Successfully wrote")
    };


    {"name":"name1"}.to_string()
}
