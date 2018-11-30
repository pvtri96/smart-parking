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
import { ContextConsumer } from "../Container/Context";

export class GuardParkingLots extends React.Component {
  requestRef = Firebase.database().ref("requests");

  state = {
    result: null,
    error: null
  };

  public render() {
    return (
      <Card>
        <CardHeader title="Request booking in a parking lot (Guard)" />
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
                    placeholder={"Request key"}
                  />
                </Grid>
                <Grid item xs={12}>
                  <Button
                    variant="contained"
                    color="primary"
                    disabled={!requestKey}
                    onClick={() => this.accept(requestKey)}
                  >
                    Accept
                  </Button>
                  <Button
                    variant="contained"
                    color="primary"
                    onClick={() => this.reject(requestKey)}
                    disabled={!requestKey}
                    style={{ marginLeft: 16 }}
                  >
                    Reject
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

  private accept = (requestKey: string) => {
    if (!requestKey) return;
    this.requestRef.child(requestKey).once(
      "value",
      snapshot => {
        const request = snapshot.val();
        snapshot.ref.set({
          ...request,
          status: "ACCEPT_BOOKING_PARKING_LOT"
        });
      },
      (error: any) => this.setState({ error })
    );
  };

  private reject = (requestKey: string) => {
    if (!requestKey) return;
    this.requestRef.child(requestKey).once(
      "value",
      snapshot => {
        const request = snapshot.val();
        snapshot.ref.set({
          ...request,
          status: "REJECT_BOOKING_PARKING_LOT"
        });
      },
      (error: any) => this.setState({ error })
    );
  };

  private reset = () => {
    this.setState({
      requestKey: "",
      result: null,
      error: null
    });
  };
}

export default GuardParkingLots;
