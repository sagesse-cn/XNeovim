//
//  Runtime.swift
//  XVim
//
//  Created by sagesse on 18/09/2017.
//  Copyright © 2017 SAGESSE. All rights reserved.
//

import Cocoa

internal enum Runtime {
    internal enum Method: Logport {
        internal static func merge(_ source: AnyClass, to destination: String, prefix: String, override: Bool = false) {
            NSClassFromString(destination).map {
                merge(source, to: $0, prefix: prefix, override: override)
            }
        }
        internal static func merge(_ source: AnyClass, to destination: AnyClass, prefix: String, override: Bool = false) {
            `import`(source, to: destination, prefix: prefix, override: override)
            
            guard let ms = object_getClass(source), let md = object_getClass(destination) else {
                return
            }
            
            `import`(ms, to: md, prefix: prefix, override: override)
        }
        
        private static func `import`(_ source: AnyClass, to destination: AnyClass, prefix: String, override: Bool) {
            // need to repeat filtering method
            var count: UInt32 = 0
            var methods: [ObjectiveC.Selector: ObjectiveC.Method] = [:]
            
            // gets the all method
            if let descriptions = class_copyMethodList(source, &count) {
                (0 ..< Int(count)).forEach { index in
                    let method = descriptions.advanced(by: index).move()
                    let name = method_getName(method)
                    
                    methods[name] = method
                }
            }
            
            // copy all method if needed
            methods.forEach { name, method in
                // copy method to class
                guard !class_addMethod(destination, name, method_getImplementation(method), method_getTypeEncoding(method)), override else {
                    logger.debug?.write("\(destination) add method: \(name)")
                    return

                }
                // the init method is not supported
                guard !NSStringFromSelector(name).hasPrefix("init") && !NSStringFromSelector(name).hasPrefix(".") else {
                    return
                }
                
                // add failed, override it
                guard class_replaceMethod(destination, name, method_getImplementation(method), method_getTypeEncoding(method)) == nil else {
                    logger.debug?.write("\(destination) replace method: \(name)")
                    return
                }
                // copy failed
            }
            
            // merge all method
            methods.forEach {
                // get origin the method, can't use $1
                guard let m1 = class_getInstanceMethod(destination, $0.key) else {
                    return
                }
                
                // generate method info
                let name = NSStringFromSelector($0.key) as NSString
                let range = name.range(of: prefix)
                
                // the method need merge?
                guard range.location != NSNotFound else {
                    return
                }
                
                // get need merge the method
                guard let m2 = class_getInstanceMethod(destination, Selector(name.substring(from: range.location + range.length))) else {
                    return
                }

                method_exchangeImplementations(m1, m2)
                
                logger.debug?.write("\(destination) exchange method: \(name) => \($0.key)")
            }
        }

    }
    internal enum Property {
        static func lazy<T>(_ obj: AnyObject, selector: Selector, newValue: () -> T) -> T {
            // the object is hit cache?
            if let object: T = get(obj, selector: selector) {
                return object
            }
            // generate an new object
            let object = newValue()
            set(obj, selector: selector, newValue: object)
            return object
        }
        static func set<T>(_ obj: AnyObject, selector: Selector, newValue: T?) {
            return objc_setAssociatedObject(obj, UnsafeRawPointer(bitPattern: selector.hashValue)!, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        static func get<T>(_ obj: AnyObject, selector: Selector) -> T? {
            return objc_getAssociatedObject(obj, UnsafeRawPointer(bitPattern: selector.hashValue)!) as? T
        }
    }
    internal enum Ivar {
        static func offset(_ obj: AnyObject, name: String) -> Int? {
            return offset(type(of: obj), name: name)
        }
        static func offset(_ cls: AnyClass, name: String) -> Int? {
            return class_getInstanceVariable(cls, name).map { ivar_getOffset($0) }
        }
        
        
        static func dump(_ cls: AnyClass) {
            
            var count: UInt32 = 0
            var result: Array<String> = []
            
            let allTypes: [(type: String, size: Int, value: String?)] = [
                ("Any?", MemoryLayout<Any?>.stride, nil),
                ("Any", MemoryLayout<Any>.stride, "0"),
                
                ("String", MemoryLayout<String>.stride, "\"\""),
                ("String?", MemoryLayout<String?>.stride, nil),

                ("AnyObject?", MemoryLayout<AnyObject?>.stride, nil),
            ]
            
            _ = class_copyIvarList(cls, &count).map { ptr in
                //
                (0 ..< Int(count)).reversed().reduce(class_getInstanceSize(cls)) { total, index in
                    let ivar = ptr.advanced(by: index).move()
                    
                    let offset = ivar_getOffset(ivar)
                    let size = total - offset
                    
                    var name = ivar_getName(ivar).map { String(cString: $0) } ?? "__unknow_\(offset)"
                    
                    let tx = allTypes.first { $0.size == size }
                    let otype = tx?.type ?? "Runtime.Ivar.Multiple\(Int(size / 8))<Int64>"
                    var ovalue = tx?.value.map { " = \($0)" }
                    
                    if tx == nil {
                        ovalue = " = 0"
                    }
                    
                    name = name.replacingOccurrences(of: ".", with: "_")
               
                        
                    result.append("var \(name): \(otype)\(ovalue ?? "") // offset: \(offset), size: \(size)")
                    
                    return offset
                }
            }
            
            result.reversed().forEach {
                print($0)
            }
        }
        struct Multiple2<T: ExpressibleByIntegerLiteral>: ExpressibleByIntegerLiteral {
            
            typealias IntegerLiteralType = T.IntegerLiteralType
            
            var value1: T
            var value2: T
            
            init(integerLiteral value: IntegerLiteralType) {
                value1 = .init(integerLiteral: value)
                value2 = .init(integerLiteral: value)
            }
        }
        struct Multiple4<T: ExpressibleByIntegerLiteral>: ExpressibleByIntegerLiteral {
            
            typealias IntegerLiteralType = T.IntegerLiteralType
            
            var value1: Multiple2<T>
            var value2: Multiple2<T>
            
            init(integerLiteral value: IntegerLiteralType) {
                value1 = .init(integerLiteral: value)
                value2 = .init(integerLiteral: value)
            }
        }
        struct Multiple6<T: ExpressibleByIntegerLiteral>: ExpressibleByIntegerLiteral {
            
            typealias IntegerLiteralType = T.IntegerLiteralType
            
            var value1: Multiple2<T>
            var value2: Multiple4<T>
            
            init(integerLiteral value: IntegerLiteralType) {
                value1 = .init(integerLiteral: value)
                value2 = .init(integerLiteral: value)
            }
        }
        struct Multiple8<T: ExpressibleByIntegerLiteral>: ExpressibleByIntegerLiteral {
            
            typealias IntegerLiteralType = T.IntegerLiteralType
            
            var value1: Multiple4<T>
            var value2: Multiple4<T>
            
            init(integerLiteral value: IntegerLiteralType) {
                value1 = .init(integerLiteral: value)
                value2 = .init(integerLiteral: value)
            }
        }
        struct Multiple10<T: ExpressibleByIntegerLiteral>: ExpressibleByIntegerLiteral {
            
            typealias IntegerLiteralType = T.IntegerLiteralType
            
            var value1: Multiple2<T>
            var value2: Multiple8<T>
            
            init(integerLiteral value: IntegerLiteralType) {
                value1 = .init(integerLiteral: value)
                value2 = .init(integerLiteral: value)
            }
        }
        struct Multiple16<T: ExpressibleByIntegerLiteral>: ExpressibleByIntegerLiteral {
            
            typealias IntegerLiteralType = T.IntegerLiteralType
            
            var value1: Multiple8<T>
            var value2: Multiple8<T>
            
            init(integerLiteral value: IntegerLiteralType) {
                value1 = .init(integerLiteral: value)
                value2 = .init(integerLiteral: value)
            }
        }
        struct Multiple32<T: ExpressibleByIntegerLiteral>: ExpressibleByIntegerLiteral {
            
            typealias IntegerLiteralType = T.IntegerLiteralType
            
            var value1: Multiple16<T>
            var value2: Multiple16<T>
            
            init(integerLiteral value: IntegerLiteralType) {
                value1 = .init(integerLiteral: value)
                value2 = .init(integerLiteral: value)
            }
        }
        struct Multiple64<T: ExpressibleByIntegerLiteral>: ExpressibleByIntegerLiteral {
            
            typealias IntegerLiteralType = T.IntegerLiteralType
            
            var value1: Multiple32<T>
            var value2: Multiple32<T>
            
            init(integerLiteral value: IntegerLiteralType) {
                value1 = .init(integerLiteral: value)
                value2 = .init(integerLiteral: value)
            }
        }
    }
}

/// 自省
func scheck(_ x: AnyObject) {
    scheck(type(of: x))
}
func scheck(_ x: AnyClass) {
    guard x !== NSObject.self else {
        return
    }

    var ivarcnt: UInt32 = 0
    var propertycnt: UInt32 = 0
    var methodcnt: UInt32 = 0
    //var protocolcnt: UInt32 = 0

    let ivars = class_copyIvarList(x, &ivarcnt)
    let propertys = class_copyPropertyList(x, &propertycnt)
    let methods = class_copyMethodList(x, &methodcnt)
    //let protocols = class_copyProtocolList(self.dynamicType, &protocolcnt)

    let className = NSStringFromClass(x)

    for i in 0 ..< ivarcnt {
        let v = ivars?.advanced(by: Int(i)).pointee
        let name = NSString(utf8String: ivar_getName(v!)!) ?? "<Unknow>"
        let type = NSString(utf8String: ivar_getTypeEncoding(v!)!) ?? "<Unknow>"
        let offset = ivar_getOffset(v!)
        print("[SCheck]: \(className).ivar: \(name)(\(offset)) => \(type)")
    }
    for i in 0 ..< propertycnt {
        let v = propertys?.advanced(by: Int(i)).pointee
        let name = NSString(utf8String: property_getName(v!)) ?? "<Unknow>"
        let type = NSString(utf8String: property_getAttributes(v!)!) ?? "<Unknow>"
        print("[SCheck]: \(className).property: \(name) => \(type)")
    }
    for i in 0 ..< methodcnt {
        let v = methods?.advanced(by: Int(i)).pointee
        let name = NSStringFromSelector(method_getName(v!))
        let type = NSString(utf8String: method_getTypeEncoding(v!)!) ?? "<Unknow>"
        print("[SCheck]: \(className).method: \(name) => \(type)")
    }

    //free(protocols)
    free(methods)
    free(propertys)
    free(ivars)

    x.superclass().map { scheck($0) }
}

