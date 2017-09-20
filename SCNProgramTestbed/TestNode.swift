//
//  TestNode.swift
//  SCNProgramTestbed
//
//  Created by Hiroaki Yamane on 9/20/17.
//  Copyright © 2017 Hiroaki Yamane. All rights reserved.
//

import Foundation
import SceneKit

class TestNode: SCNNode {
    
    struct VertexInfo {
        var position: float3
        var uv: float2
        var normal: float3
    }
    
    override init() {
        super.init()
        setup()
    }
    
    func setup() {
        
        var (vertexInfo, indices) = createPlane(sx: 1.0, sy: 1.0, nx: 10, ny: 10)
        
        let vertexData = Data(bytes: &vertexInfo, count: MemoryLayout<VertexInfo>.stride * vertexInfo.count)
        let indicesData = Data(bytes: &indices, count: MemoryLayout<UInt32>.stride * indices.count)
        
        let geom = SCNGeometry(sources: [
            SCNGeometrySource(data: vertexData, semantic: .vertex, vectorCount: vertexInfo.count, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: MemoryLayout<Float>.size, dataOffset: 0, dataStride: MemoryLayout<VertexInfo>.stride)
            ], elements: [
                SCNGeometryElement(data: indicesData, primitiveType: .triangles, primitiveCount: indices.count / 3, bytesPerIndex: MemoryLayout<UInt32>.size),
                SCNGeometryElement(data: indicesData, primitiveType: .point, primitiveCount: indices.count, bytesPerIndex: MemoryLayout<UInt32>.size)
            ])
        
        geometry = geom
        let material = SCNMaterial()
        
        let program = SCNProgram()
        
        program.vertexFunctionName = "vertex_function"
        program.fragmentFunctionName = "fragment_function"
        
        material.program = program
        material.isDoubleSided = true
        
        geometry!.firstMaterial = material
        program.isOpaque = false

        
    }
    

    
    func createPlane(sx: Float = 1.0, sy: Float = 1.0, nx: UInt32 = 1, ny: UInt32 = 1) -> ([VertexInfo], [UInt32]){
        
        var cells: [UInt32] = []
        var vertexInfo: [VertexInfo] = []
        
        for iy: UInt32 in 0...ny {
            for ix: UInt32 in 0...nx {
                let u = Float(ix) / Float(nx)
                let v = Float(iy) / Float(ny)
                let x = -sx / 2.0 + u * sx // starts on the left
                let y = sy / 2.0 - v * sy // starts at the top
                vertexInfo.append(VertexInfo(position: float3(x, y, 0), uv: float2(u, 1.0 - v), normal: float3(0, 0, 1)))
                
                if iy < ny && ix < nx {
                    
                    cells.append(iy * (nx + 1) + ix)
                    cells.append((iy + 1) * (nx + 1) + ix + 1)
                    cells.append(iy * (nx + 1) + ix + 1)
                    
                    cells.append((iy + 1) * (nx + 1) + ix + 1)
                    cells.append(iy * (nx + 1) + ix)
                    cells.append((iy + 1) * (nx + 1) + ix)
                }
            }
        }
        
        return (vertexInfo, cells)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

