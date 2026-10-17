extern float time;
int glitchRate = 8;
float amount = 0.1;

float hash(float x){
    return fract(sin(x)*43758.5453);
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screenPos){
    vec2 offset;
    if (uv.x < 0.5){
        offset.y = hash(floor(time*(glitchRate-1)));
        if (uv.y < 0.5){
            offset.x = hash(floor(time*(glitchRate+1)));
        }
        else{
            offset.x = hash(floor(time*(glitchRate+2)));
        }
    }
    else{
        offset.y = hash(floor(time*(glitchRate-2)));
        if (uv.y < 0.5){
            offset.x = hash(floor(time*(glitchRate+3)));
        }
        else{
            offset.x = hash(floor(time*(glitchRate+4)));
        }
    }
    offset *= amount;
    offset -= amount/2;
    vec4 pixelR = Texel(tex, uv+offset);
    vec4 pixelG = Texel(tex, uv-offset);
    vec4 pixelB = Texel(tex, uv+offset*2);
    return vec4(pixelR.x, pixelG.y, pixelB.z, pixelR.a);
}