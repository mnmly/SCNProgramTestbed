//
//  functions.metal
//  SCNProgramTestbed
//
//  Created by Hiroaki Yamane on 9/20/17.
//  Copyright © 2017 Hiroaki Yamane. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include <SceneKit/scn_metal>

typedef struct {
    float4 position [[ attribute(SCNVertexSemanticPosition) ]];
    float2 texcoords [[ attribute(SCNVertexSemanticTexcoord0) ]];
} vertexInput;


struct VertexOut
{
    float4 position [[position]];
    float pointSize [[point_size]];
//    float2 uv;
};


typedef struct {
    float4x4 modelTransform;
    float4x4 inverseModelTransform;
    float4x4 modelViewTransform;
    float4x4 inverseModelViewTransform;
    float4x4 normalTransform; // This is the inverseTransposeModelViewTransform, need for normal transformation
    float4x4 modelViewProjectionTransform;
    float4x4 inverseModelViewProjectionTransform;
    float2x3 boundingBox;
    float2x3 worldBoundingBox;
} SCNNodeBuffer;

vertex VertexOut vertex_function(vertexInput _geometry [[ stage_in ]],
                                          const device SCNSceneBuffer &scn_frame [[buffer(0) ]],
                                          const device SCNNodeBuffer &scn_node [[ buffer(1) ]],
                                          uint vid [[vertex_id]]) {

    VertexOut out;
    out.position = scn_node.modelViewProjectionTransform * float4(_geometry.position.xyz, 1.0);
//    out.uv = uv;
    out.pointSize = 2.0;
    return out;
}

fragment half4 fragment_function(VertexOut in [[stage_in]], const device SCNSceneBuffer &scn_frame [[buffer(0) ]]) {
    return half4( 1.0, 1.0, scn_frame.sinTime, scn_frame.sinTime);
}
