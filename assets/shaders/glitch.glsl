uniform float time;
float glitchRate = 3.0;
float amount = 0.1;

float hash(float x){
    return fract(sin(x)*43758.5453);
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screenPos){
    vec2 offset = vec2(0, 0);
    if (uv.x < 0.5){
        offset.y = hash(floor(time*(glitchRate-1.0)));
        if (uv.y < 0.5){
            offset.x = hash(floor(time*(glitchRate+1.0)));
        }
        else{
            offset.x = hash(floor(time*(glitchRate+2.0)));
        }
    }
    else{
        offset.y = hash(floor(time*(glitchRate-2.0)));
        if (uv.y < 0.5){
            offset.x = hash(floor(time*(glitchRate+3.0)));
        }
        else{
            offset.x = hash(floor(time*(glitchRate+4.0)));
        }
    }
    offset *= amount;
    offset -= amount/2.0;
    vec4 pixelR = Texel(tex, uv+offset);
    vec4 pixelG = Texel(tex, uv-offset);
    vec4 pixelB = Texel(tex, uv+offset*2.0);
    return vec4(pixelR.x, pixelG.y, pixelB.z, pixelR.a);
}