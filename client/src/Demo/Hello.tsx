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
    name: "",
    result: null,
    error: null
  };

  public render() {
    return (
      <Card>
        <CardHeader title="Hello API" />
        <CardContent>
          <Grid container spacing={16}>
            <Grid item xs={12}>
              <Typography>Type your name then click submit</Typography>
            </Grid>
            <Grid item xs={12}>
              <Input
                value={this.state.name}
                onChange={e => this.setState({ name: e.target.value })}
                placeholder={"Your name"}
              />
            </Grid>
            <Grid item xs={12}>
              <Button
                variant="contained"
                color="primary"
                disabled={!this.state.name}
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
    if (!this.state.name) return;
    const request = this.requestRef.push({
      clientId: "RandomString",
      type: "HELLO_WORLD",
      status: "requesting",
      payload: {
        name: this.state.name
      }
    });
    request.on("value", snapshot => {
      if (!snapshot) return;
      const result = snapshot.val();
      if (result.status === "responded" && result.response) {
        this.setState({ result: result.response });
      } else if (result.status === "responded" && result.error) {
        this.setState({ error: result.error });
      } else {
        console.log("REQUESTING", result);
      }
    });
  };
}

export default HelloDemo;
