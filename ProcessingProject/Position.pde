public class Position {
    float x = 1.0f;
    float y = 1.0f;
    float z = 1.0f;

    public synchronized void setRandomNewPosition(float a)
    {
        x += (Math.random()-.5)*a;
        y += (Math.random()-.5)*a;
        z += (Math.random()-.5)*a;
    }

    public void setPositionString(String positionString)
    {
        String[] split = positionString.split(",");
        x = Float.parseFloat(split[0]);
        y = Float.parseFloat(split[1]);
        z = Float.parseFloat(split[2]);
    }

    public synchronized String getPositionString()
    {
        return""+x+","+y+","+z;
    }

    public synchronized void setNewPosition(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}