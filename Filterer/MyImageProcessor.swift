import UIKit

public enum FilterIntensity {
    case None, Weak, Medium, Strong
}


public class Filter:NSObject {
    var image : UIImage!
    var intensity : FilterIntensity
    var filterName : String!
    init(image:UIImage , name:String, intensity:FilterIntensity) {
        self.image = image
        self.filterName = name
        self.intensity = intensity
    }
    func applyFilter() ->UIImage? {
        print("The filter","*",self.filterName, "*", "is not available. Valid choices are: greyscale,blurry,bright,dark,sepia,blue")
        return self.image
    }
    
}

class GreyScaleFilter: Filter {
    override func applyFilter() ->UIImage? {
        guard let image = self.image else { return nil }
        guard let rgbaImage = RGBAImage(image:image) else { return nil }
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let avg  = (Int(pixel.red) + Int(pixel.green) + Int(pixel.blue))/3
                pixel.red = UInt8(avg)
                pixel.green = UInt8(avg)
                pixel.blue = UInt8(avg)
                rgbaImage.pixels[index] = pixel
            }
        }
        let filteredImage = rgbaImage.toUIImage()
        return filteredImage
        
    }
    
}

class BlurryFilter: Filter {
    override func applyFilter() ->UIImage? {
        guard let image = self.image else { return nil }
        guard let rgbaImage = RGBAImage(image:image) else { return nil }
        
        var kernelSize = 1
        switch self.intensity {
        case .None :
            return image
        case FilterIntensity.Weak :
            kernelSize = 3
        case .Medium :
            kernelSize = 5
        case .Strong :
            kernelSize = 9
        }

        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                let indexX1 = max(y * rgbaImage.width + (x - 1),0)
                let indexX2 = min(y * rgbaImage.width + (x + 1),rgbaImage.pixels.count - 1)
                
                
                var pixel = rgbaImage.pixels[index]
                let pixelX1 = rgbaImage.pixels[indexX1]
                let pixelX2 = rgbaImage.pixels[indexX2]
                
                
                var avgRed = (Int(pixel.red) + Int(pixelX1.red) + Int(pixelX2.red))
                
                var avgGreen = (Int(pixel.green) + Int(pixelX1.green) + Int(pixelX2.green))
                
                var avgBlue = (Int(pixel.blue) + Int(pixelX1.blue) + Int(pixelX2.blue))
                
                
                if kernelSize > 3 {
                    let indexY1 = max((y - 1) * rgbaImage.width + x,0)
                    let indexY2 = min((y + 1) * rgbaImage.width + x, rgbaImage.pixels.count - 1)
                    
                    let pixelY1 = rgbaImage.pixels[indexY1]
                    let pixelY2 = rgbaImage.pixels[indexY2]
                    
                    avgRed +=  (Int(pixelY1.red) + Int(pixelY2.red))
                    avgGreen +=  (Int(pixelY1.green) + Int(pixelY2.green))
                    avgBlue +=  (Int(pixelY1.blue) + Int(pixelY2.blue))
                    
                }
                
                if(kernelSize > 5) {
                    let index6 = max((y - 1) * rgbaImage.width + (x - 1),0)
                    let index7 = max((y - 1) * rgbaImage.width + (x + 1),0)
                    let index8 = min(max((y + 1) * rgbaImage.width + (x - 1),0),rgbaImage.pixels.count - 1)
                    let index9 = min((y + 1) * rgbaImage.width + (x + 1),rgbaImage.pixels.count - 1)
                    
                    let pixel6 = rgbaImage.pixels[index6]
                    let pixel7 = rgbaImage.pixels[index7]
                    let pixel8 = rgbaImage.pixels[index8]
                    let pixel9 = rgbaImage.pixels[index9]
                    avgRed +=  (Int(pixel6.red) + Int(pixel7.red) + Int(pixel8.red) + Int(pixel9.red))
                    avgGreen +=  (Int(pixel6.green) + Int(pixel7.green) + Int(pixel8.green) + Int(pixel9.green))
                    avgBlue +=  (Int(pixel6.blue) + Int(pixel7.blue) + Int(pixel8.blue) + Int(pixel9.blue))
                }
                
                pixel.red = UInt8(max(0,min(255,avgRed / kernelSize)))
                
                pixel.green = UInt8(max(0,min(255,avgGreen / kernelSize)))
                
                pixel.blue = UInt8(max(0,min(255,avgBlue / kernelSize)))
                
                
                rgbaImage.pixels[index] = pixel
            }
        }
        let filteredImage = rgbaImage.toUIImage()
        return filteredImage
    }
   
    
}

class BrightFilter: Filter {
    override func applyFilter() ->UIImage? {
        guard let image = self.image else { return nil }
        guard let rgbaImage = RGBAImage(image:image) else { return nil }
        var brightnessValue = 0
        switch self.intensity {
        case .None :
            brightnessValue = 0
        case .Weak :
            brightnessValue = 40
        case .Medium :
            brightnessValue = 90
        case .Strong :
            brightnessValue = 170
        }
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let newRed = max(0,min(255,Int(pixel.red) + brightnessValue))
                let newGreen = max(0,min(255,Int(pixel.green) + brightnessValue))
                let newBlue = max(0,min(255,Int(pixel.blue) + brightnessValue))
                
                pixel.red = UInt8(newRed)
                pixel.green = UInt8(newGreen)
                pixel.blue = UInt8(newBlue)
                rgbaImage.pixels[index] = pixel
                
            }
        }
        let filteredImage = rgbaImage.toUIImage()
        return filteredImage
        
    }
}

class DarkFilter: Filter {
    override func applyFilter() ->UIImage? {
        guard let image = self.image else { return nil }
        guard let rgbaImage = RGBAImage(image:image) else { return nil }
        var darknessValue = 0
        switch intensity {
        case .None :
            darknessValue = 0
        case .Weak :
            darknessValue = 40
        case .Medium :
            darknessValue = 90
        case .Strong :
            darknessValue = 170
        }
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let newRed = max(0,min(255,Int(pixel.red) - darknessValue))
                let newGreen = max(0,min(255,Int(pixel.green) - darknessValue))
                let newBlue = max(0,min(255,Int(pixel.blue) - darknessValue))
                
                pixel.red = UInt8(newRed)
                pixel.green = UInt8(newGreen)
                pixel.blue = UInt8(newBlue)
                rgbaImage.pixels[index] = pixel
                
            }
        }
        let filteredImage = rgbaImage.toUIImage()
        return filteredImage
    }
    
}

class SepiaFilter: Filter {
    override func applyFilter() ->UIImage? {
        guard let image = self.image else { return nil }
        var newImage = image
        var depth = 0
        switch intensity {
        case .None :
            depth = 0
        case .Weak :
            depth = 30
        case .Medium :
            depth = 100
        case .Strong :
            depth = 150
        }
        
        if depth > 0 {
            let greyScaleFilter = GreyScaleFilter(image: image, name: "greyscale",intensity: intensity)
            newImage = greyScaleFilter.applyFilter()!
        }
        
        guard let rgbaImage = RGBAImage(image:newImage) else { return nil }
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let red : Double = Double(pixel.red)
                let green : Double = Double(pixel.green)
                let blue : Double = Double(pixel.blue)
                
                
                let newRed = red + Double(depth * 2)
                let newGreen = green + Double(depth)
                
                
                pixel.red = UInt8(max(0,min(255,newRed)))
                pixel.green = UInt8(max(0,min(255,newGreen)))
                pixel.blue = UInt8(max(0,min(255,blue)))
                rgbaImage.pixels[index] = pixel
            }
        }
        let filteredImage = rgbaImage.toUIImage()
        return filteredImage
        
    }
    
}


class Blue: Filter {
    override func applyFilter() ->UIImage? {
        guard let image = self.image else { return nil }
        
        var depth = 0
        switch intensity {
        case .None :
            depth = 0
        case .Weak :
            depth = 90
        case .Medium :
            depth = 180
        case .Strong :
            depth = 240
        }
        
        guard let rgbaImage = RGBAImage(image:image) else { return nil }
        
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let blue : Double = Double(pixel.blue)

                let newBlue = blue + Double(depth) * 1.5
                
                pixel.blue = UInt8(max(0,min(255,newBlue)))
                rgbaImage.pixels[index] = pixel
            }
        }
        let filteredImage = rgbaImage.toUIImage()
        return filteredImage
        
    }
    
}


public struct MyImageProcessor {
    var filters = [Filter]()
    var image: UIImage?

    public init() {
    }
    public init(image:UIImage, filtersNamesAndIntensities: [String : FilterIntensity]...) {
        self.image = image
        var filterName : String
        var intensity : FilterIntensity
        for filterDefinition in filtersNamesAndIntensities {
            filterName = Array(filterDefinition.keys)[0]
            intensity = filterDefinition[filterName]!
            if filterName.caseInsensitiveCompare("greyscale") == NSComparisonResult.OrderedSame {
                let filter:Filter = GreyScaleFilter(image: image, name: "greyscale" , intensity:intensity)
                filters.append(filter)
            }
            else  if filterName.caseInsensitiveCompare("blurry") == NSComparisonResult.OrderedSame {
                let filter:Filter = BlurryFilter(image: image, name: "blurry" , intensity:intensity)
                filters.append(filter)
            }
            
            else  if filterName.caseInsensitiveCompare("bright") == NSComparisonResult.OrderedSame {
                let filter:Filter = BrightFilter(image: image, name: "bright" , intensity:intensity)
                filters.append(filter)
            }
            
            else  if filterName.caseInsensitiveCompare("dark") == NSComparisonResult.OrderedSame {
                let filter:Filter = DarkFilter(image: image, name: "dark" , intensity:intensity)
                filters.append(filter)
            }
            else  if filterName.caseInsensitiveCompare("sepia") == NSComparisonResult.OrderedSame {
                let filter:Filter = SepiaFilter(image: image, name: "sepia" , intensity:intensity)
                filters.append(filter)
            }
                
            else  if filterName.caseInsensitiveCompare("blue") == NSComparisonResult.OrderedSame {
                let filter:Filter = Blue(image: image, name: "blue", intensity:intensity)
                filters.append(filter)
            }
            else {
                let filter:Filter = Filter(image: image, name: "none" , intensity:intensity)
                filters.append(filter)
            }
            
        }

       
        for filter in self.filters {
            filter.image = self.image
            self.image = filter.applyFilter()
        }
        
    }
    
    public func filter(image:UIImage , filterName:String) -> UIImage {
        
        var filteredImage : UIImage!
        let filter:Filter!
        if filterName.caseInsensitiveCompare("greyscale") == NSComparisonResult.OrderedSame {
             filter = GreyScaleFilter(image: image, name: "greyscale" , intensity:FilterIntensity.Medium)
    

        }
        
        else  if filterName.caseInsensitiveCompare("blurry") == NSComparisonResult.OrderedSame {
            filter = BlurryFilter(image: image, name: "blurry" , intensity:FilterIntensity.Strong)
        }
            
        else  if filterName.caseInsensitiveCompare("bright") == NSComparisonResult.OrderedSame {
            filter = BrightFilter(image: image, name: "bright" , intensity:FilterIntensity.Medium)
        }
            
        else  if filterName.caseInsensitiveCompare("dark") == NSComparisonResult.OrderedSame {
            filter = DarkFilter(image: image, name: "dark" , intensity:FilterIntensity.Medium)
        }
        else  if filterName.caseInsensitiveCompare("sepia") == NSComparisonResult.OrderedSame {
            filter = SepiaFilter(image: image, name: "sepia" , intensity:FilterIntensity.Medium)
        }
            
        else  if filterName.caseInsensitiveCompare("blue") == NSComparisonResult.OrderedSame {
            filter = Blue(image: image, name: "blue", intensity:FilterIntensity.Medium)
            filteredImage = filter.applyFilter()
        }
        else {
            filter = Filter(image: image, name: "none" , intensity:FilterIntensity.Medium)
        }
        filteredImage = filter.applyFilter()
        return filteredImage
    
    }
}