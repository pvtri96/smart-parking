import * as React from "react";
import {
  Card,
  CardHeader,
  CardContent,
  Input,
  Typography,
  Button,
  Grid
} from "@material-ui/core";
import * as Firebase from "firebase";

export class HelloDemo extends React.Component {
  requestRef = Firebase.database().ref("requests");

  state = {
    lat: "",
    lng: "",
    result: null,
    error: null
  };

  public render() {
    return (
      <Card>
        <CardHeader title="Find parking lots API" />
        <CardContent>
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
                onClick={this.request}
              >
                Request
              </Button>
            </Grid>
            <Grid item xs={12}>
              {this.state.result && (
                <code>{JSON.stringify(this.state.result)}</code>
              )}
              {this.state.error && (
                <code>{JSON.stringify(this.state.error)}</code>
              )}
            </Grid>
          </Grid>
        </CardContent>
      </Card>
    );
  }

  private request = () => {
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
    request.on("value", snapshot => {
      if (!snapshot) return;
      const result = snapshot.val();
      if (result.status === "RESPONSE_FIND_PARKING_LOT" && result.response) {
        this.setState({ result: result.response });
      } else if (result.status === "RESPONSE_FIND_PARKING_LOT" && result.error) {
        this.setState({ error: result.error });
      } else {
        console.log("REQUESTING", result);
      }
    });
  };
}

export default HelloDemo;
