import * as React from "react";
import {
  Card,
  CardHeader,
  CardContent,
  Input,
  Typography,
  Button,
  Grid,
  CircularProgress
} from "@material-ui/core";
import * as Firebase from "firebase";
import { ContextConsumer } from "../Container/Context";

export class ParkerBookParkingLots extends React.Component {
  requestRef = Firebase.database().ref("requests");

  state = {
    parkingLotId: "",
    result: null,
    error: null,
    loading: false
  };

  public render() {
    return (
      <Card>
        <CardHeader title="Request booking in a parking lot (Parker)" />
        <CardContent>
          <ContextConsumer>
            {({ requestKey }) => (
              <Grid container spacing={16}>
                <Grid item xs={12}>
                  <Typography>Type your location then click submit</Typography>
                </Grid>
                <Grid item xs={12}>
                  <Input
                    readOnly
                    value={requestKey}
                    onChange={e => this.setState({ lng: e.target.value })}
                    placeholder={"Request key"}
                  />
                </Grid>
                <Grid item xs={12}>
                  <Input
                    value={this.state.parkingLotId}
                    onChange={e =>
                      this.setState({ parkingLotId: e.target.value })
                    }
                    placeholder={"Parking lot ID"}
                  />
                </Grid>
                <Grid item xs={12}>
                  <Button
                    variant="contained"
                    color="primary"
                    disabled={!requestKey || !this.state.parkingLotId}
                    onClick={() => this.request(requestKey)}
                  >
                    Request
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
                  {this.state.loading && <CircularProgress />}
                  {this.state.result && (
                    <code>{JSON.stringify(this.state.result)}</code>
                  )}
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

  private request = (requestKey: string) => {
    if (!requestKey) return;
    if (!this.state.parkingLotId) return;
    this.requestRef.child(requestKey).once("value", snapshot => {
      const request = snapshot.val();
      this.requestRef
        .child(requestKey)
        .set({
          ...request,
          status: "REQUEST_BOOKING_PARKING_LOT",
          payload: {
            parkingLotId: this.state.parkingLotId
          }
        })
        .then(() => this.setState({ loading: true }));
    });
    this.requestRef.child(requestKey).on("value", snapshot => {
      if (!snapshot) return;
      const result = snapshot.val();
      console.log(result);
      if (result.status === "MOVING_TO_PARKING_LOT" && result.error) {
        this.setState({ error: result.error, loading: false });
      } else if (result.status === "MOVING_TO_PARKING_LOT") {
        this.setState({ result: result.status, loading: false });
      } else if (
        result.status === "REJECT_BOOKING_PARKING_LOT" &&
        result.error
      ) {
        this.setState({ error: result.error, loading: false });
      } else if (result.status === "REJECT_BOOKING_PARKING_LOT") {
        this.setState({ result: result.status, loading: false });
      } else {
        console.log("REQUESTING", result);
      }
    });
  };

  private reset = () => {
    this.setState({
      requestKey: "",
      parkingLotId: "",
      result: null,
      error: null
    });
  };
}

export default ParkerBookParkingLots;
