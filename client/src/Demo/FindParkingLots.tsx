import * as React from "react";
import {
  Card,
  CardHeader,
  CardContent,
  Input,
  Typography,
  Button,
  Grid,
  List,
  ListItem,
  ListItemIcon,
  ListItemText
} from "@material-ui/core";
import * as Firebase from "firebase";
import { ContextConsumer } from "../Container/Context";

export class FindParkingLots extends React.Component<{}, States> {
  requestRef = Firebase.database().ref("requests");

  state = {
    lat: "",
    lng: "",
    error: null,
    result: null
  };

  public render() {
    return (
      <Card>
        <CardHeader title="Find parking lots API" />
        <CardContent>
          <ContextConsumer>
            {({ requestKey, setState }) => (
              <Grid container spacing={16}>
                <Grid item xs={12}>
                  <Typography>Type your location then click submit</Typography>
                </Grid>
                <Grid item xs={12}>
                  <Input
                    value={this.state.lat}
                    onChange={e => this.setState({ lat: e.target.value })}
                    placeholder={"Your Latitude"}
                  />
                </Grid>
                <Grid item xs={12}>
                  <Input
                    value={this.state.lng}
                    onChange={e => this.setState({ lng: e.target.value })}
                    placeholder={"Your Longitude"}
                  />
                </Grid>
                <Grid item xs={12}>
                  <Button
                    variant="contained"
                    color="primary"
                    disabled={!this.state.lat || !this.state.lng}
                    onClick={() => this.request(setState)}
                  >
                    Request
                  </Button>
                  <Button
                    variant="contained"
                    color="primary"
                    disabled={!!(this.state.lat && this.state.lng)}
                    onClick={this.useCurrentLocation}
                    style={{ marginLeft: 16 }}
                  >
                    Use my Location
                  </Button>
                  <Button
                    variant="contained"
                    onClick={this.reset}
                    style={{ marginLeft: 16 }}
                  >
                    Reset
                  </Button>
                </Grid>
                <Grid item xs={12}>
                  <Input
                    readOnly
                    value={requestKey}
                    onChange={e => setState(e.target.value)}
                    placeholder={"Request key, for later use"}
                  />
                </Grid>
                <Grid item xs={12}>
                  <List>
                    {this.state.result &&
                      (this.state.result as any).parkingLots.map(({ id }: ParkingLot) => (
                        <ListItem>
                          <ListItemText>{id}</ListItemText>
                        </ListItem>
                      ))}
                  </List>
                  {this.state.error && (
                    <code>{JSON.stringify(this.state.error)}</code>
                  )}
                </Grid>
              </Grid>
            )}
          </ContextConsumer>
        </CardContent>
      </Card>
    );
  }

  private request = (setRequestKey: (k: string) => void) => {
    if (!this.state.lat) return;
    if (!this.state.lng) return;
    const request = this.requestRef.push({
      clientId: "RandomString",
      status: "REQUEST_FIND_PARKING_LOT",
      payload: {
        location: {
          lat: this.state.lat,
          lng: this.state.lng
        }
      }
    });
    setRequestKey(request.key as string);
    request.on("value", snapshot => {
      if (!snapshot) return;
      const result = snapshot.val();
      if (result.status === "RESPONSE_FIND_PARKING_LOT" && result.response) {
        this.setState({ result: result.response });
      } else if (
        result.status === "RESPONSE_FIND_PARKING_LOT" &&
        result.error
      ) {
        this.setState({ error: result.error });
      } else {
        console.log("REQUESTING", result);
      }
    });
  };

  private useCurrentLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(position => {
        this.setState({
          lat: position.coords.latitude,
          lng: position.coords.longitude
        });
      });
    } else {
      this.setState({ error: "Can not fetch current location" });
    }
  };

  private reset = () => {
    this.setState({
      lat: "",
      lng: "",
      error: null
    });
  };
}

interface States {
  lat: any;
  lng: any;
  error: any;
  result: null | {
    parkingLots: ParkingLot[];
  };
}

interface ParkingLot {
  id: string
}

export default FindParkingLots;
