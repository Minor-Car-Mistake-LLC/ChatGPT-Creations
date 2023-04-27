open ZXing

let decodeBarcode (imagePath: string) : string =
    let reader = BarcodeReader()
    let image = new Bitmap(imagePath)
    let result = reader.Decode(image)
    match result with
    | null -> "No barcode detected"
    | _ -> result.Text
